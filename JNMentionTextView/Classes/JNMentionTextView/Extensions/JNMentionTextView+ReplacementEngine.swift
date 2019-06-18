//
//  JNMentionTextView+ReplacementEngine.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// MentionEngine
extension JNMentionTextView {

    /**
     Replace Characters
     - Parameter item: selected pickable item.
     - Parameter selectedLocation: selected location.
     */
    func replaceCharacters(with item: JNMentionPickable, in selectedLocation: Int) {
        
        // replacement Range
        let replacementRange = NSRange(location: self.selectedSymbolLocation, length: selectedLocation - self.selectedSymbolLocation)
        let replacementText = String((self.textStorage.string as NSString).substring(with: replacementRange).first ?? Character(""))
        
        // create mention item
        let mentionItem = JNMentionEntity(item: item, symbol: replacementText)
        
        // add mentioned item as attribute
        var updatedAttributes = self.selectedSymbolAttributes
        updatedAttributes?[JNMentionTextView.JNMentionAttributeName] = mentionItem
        
        // create mention attributed string with item title and symbol attributes
        let mentionAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: item.getPickableTitle(), attributes: updatedAttributes))
        
        // replace the replacement range with mention item
        self.textStorage.replaceCharacters(in: replacementRange, with: mentionAttributedString)
        
        // append empty string after selection and replacement
        self.textStorage.append(NSAttributedString(string: " "))
        
        // set normal attributes after selection
        let maxRange = replacementRange.location + item.getPickableTitle().count
        if maxRange < self.textStorage.length {
            self.textStorage.addAttributes(self.normalAttributes, range: NSMakeRange(maxRange, 1))
        }

        // move cursor to the end of replacement
        self.moveCursor(to: replacementRange.location + item.getPickableTitle().count + 1)
        
        // empty the search string
        self.searchString = ""
    }

    /**
     Set Smart Text
     - Parameter text: smart text which m.
     - Parameter selectedLocation: selected location.
     */
    open func setSmartText(_ text: String) {
        
        /// Difference
        var difference = 0
        
        /// Attributed String
        let attributedString = NSMutableAttributedString(string: text, attributes: self.normalAttributes)
        
        // iterate through each symbol
        for (pattern, attributes) in self.mentionReplacements {
            
            // build pattern
            let updatedPattern = "(\\" + pattern + "([A-Za-z0-9]{0,}))\\s"
            
            // reset difference
            difference = 0
            
            do {

                let regex = try NSRegularExpression(pattern: updatedPattern)
                regex.enumerateMatches(in: attributedString.string, range: NSRange(location: 0, length: attributedString.length)) {
                    match, flags, stop in
                    
                    if let matchRange = match?.range(at: 1) {
                        
                        // update range
                        var updatedRange = matchRange
                        updatedRange.location += difference
                        
                        // get mention ID
                        let searchID = String((attributedString.string as NSString).substring(with: updatedRange).dropFirst())
                        
                        // get mention item for ID
                        if let item = self.mentionDelegate?.getMentionItemFor(symbol: pattern, id: searchID) {
                            
                            // create mention entity
                            let mentionItem = JNMentionEntity(item: item, symbol: pattern)
                            
                            // update attribute string by adding mention item
                            var updatedAttributes = attributes
                            updatedAttributes[JNMentionTextView.JNMentionAttributeName] = mentionItem
                            
                            // create mention attributed string
                            let mentionAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: item.getPickableTitle(),
                                                                                                                         attributes: updatedAttributes))
                            // replace the matched pattern with the mention attributed string
                            attributedString.replaceCharacters(in: updatedRange, with: mentionAttributedString)
                            
                            // check if difference is less than.
                            difference += item.getPickableTitle().count - matchRange.length
                            
                        }
                    }
                }
            }
                
            catch {
                print("An error occurred attempting to locate pattern: " +
                    "\(error.localizedDescription)")
            }
        }
        
        // set attributed text
        self.attributedText = attributedString
        
    }
}
