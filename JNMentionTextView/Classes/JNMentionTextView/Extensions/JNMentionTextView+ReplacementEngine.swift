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
        let startIndex = self.textStorage.string.index(self.textStorage.string.startIndex, offsetBy: self.selectedSymbolLocation)
       let replacementText = self.textStorage.string[startIndex]
        
        // create mention item
        let mentionItem = JNMentionEntity(item: item, symbol: String(replacementText))
        
        // add mentioned item as attribute
        var updatedAttributes = self.selectedSymbolAttributes
        updatedAttributes?[JNMentionTextView.JNMentionAttributeName] = mentionItem
        
        // create mention attributed string with item title and symbol attributes
        let mentionAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: item.getPickableTitle(), attributes: updatedAttributes))
        
        // Check if the next char after the selected loaction has space then no need to add space
        let nextCharLoaction = selectedLocation
        if nextCharLoaction < self.textStorage.string.count {
            let nextCharIndex = self.textStorage.string.index(self.textStorage.string.startIndex, offsetBy: nextCharLoaction)
            let nextChar = self.textStorage.string[nextCharIndex]
            if nextChar != " " {
                mentionAttributedString.append(NSAttributedString(string: " "))
            }
        }else{
            mentionAttributedString.append(NSAttributedString(string: " "))
        }

        
        // replace the replacement range with mention item
        self.textStorage.replaceCharacters(in: replacementRange, with: mentionAttributedString)
        
        // set normal attributes after selection
        let maxRange = replacementRange.location + item.getPickableTitle().count
        if maxRange < self.textStorage.length {
            self.textStorage.addAttributes(self.normalAttributes, range: NSMakeRange(maxRange, 1))
        }

        // move cursor to the end of replacement
        self.moveCursor(to: replacementRange.location + item.getPickableTitle().count + 1, completion: {
            self.endMentionProcess()
            
            // empty the search string
            self.searchString = ""
        })
    }

    /**
     Set Smart Text
     - Parameter text: smart text which m.
     - Parameter selectedLocation: selected location.
     */
    open func setSmartText(_ text: String) {
        
        /// Attributed String
        let attributedString = NSMutableAttributedString(string: text, attributes: self.normalAttributes)
        
        // iterate through each symbol
        for (pattern, attributes) in self.mentionReplacements {
            
            // build pattern
            let updatedPattern = "(\\" + pattern + "([A-Za-z0-9]{0,}))\\s"
            
            do {
                
                // build regex
                let regex = try NSRegularExpression(pattern: updatedPattern)
                
                // get matches
                let matches = regex.matches(in: attributedString.string, options: [], range: NSRange(attributedString.string.startIndex..<attributedString.string.endIndex, in: attributedString.string))
                
                // loop in matches in revers
                for match in matches.reversed() {
                    
                    let matchRange = match.range(at: 1)
                    
                    // get mention ID
                    let searchID = String((attributedString.string as NSString).substring(with: matchRange).dropFirst())
                    
                    // get mention item for ID
                    if let item = self.mentionDelegate?.jnMentionTextView(getMentionItemFor: pattern, id: searchID) {
                        
                        // create mention entity
                        let mentionItem = JNMentionEntity(item: item, symbol: pattern)
                        
                        // update attribute string by adding mention item
                        var updatedAttributes = attributes
                        updatedAttributes[JNMentionTextView.JNMentionAttributeName] = mentionItem
                        
                        // create mention attributed string
                        let mentionAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: item.getPickableTitle(),
                                                                                                                     attributes: updatedAttributes))
                        // replace the matched pattern with the mention attributed string
                        attributedString.replaceCharacters(in: matchRange, with: mentionAttributedString)
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
    
    /**
     Get Smart Replacement
     - Parameter text: smart text to be replaced.
     - Parameter data: [String: [JNMentionPickable]].
     - Parameter normalAttributes: Normal Attributes.
     - Parameter mentionReplacements: Mention Replacement.
     - Returns smartReplacement: smart replacement attributed string.
     */
    open class func getSmartReplacement(text: String, data: [String: [JNMentionPickable]], normalAttributes: [NSAttributedString.Key: Any], mentionReplacements: [String: [NSAttributedString.Key : Any]]) -> NSAttributedString {
        
        // add space to text
        let text = text + " "
        
        /// Attributed String
        let attributedString = NSMutableAttributedString(string: text, attributes: normalAttributes)
        
        // iterate through each symbol
        for (pattern, attributes) in mentionReplacements {
            
            // build pattern
            let updatedPattern = "(\\" + pattern + "([A-Za-z0-9]{0,}))\\s"
            
            do {
                
                // build regex
                let regex = try NSRegularExpression(pattern: updatedPattern)
                
                // get matches
                let matches = regex.matches(in: attributedString.string, options: [], range: NSRange(attributedString.string.startIndex..<attributedString.string.endIndex, in: attributedString.string))
                
                // loop in matches in revers
                for match in matches.reversed() {
                    
                    let matchRange = match.range(at: 1)
                    
                    // get mention ID
                    let searchID = String((attributedString.string as NSString).substring(with: matchRange).dropFirst())
                    
                    // get mention item for ID
                    if let item = data[pattern]?.first(where: { $0.getPickableIdentifier() == searchID}) {
                        
                        // create mention entity
                        let mentionItem = JNMentionEntity(item: item , symbol: pattern)
                        
                        // update attribute string by adding mention item
                        var updatedAttributes = attributes
                        updatedAttributes[JNMentionTextView.JNMentionAttributeName] = mentionItem
                        
                        // create mention attributed string
                        let mentionAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: item.getPickableTitle(),
                                                                                                                     attributes: updatedAttributes))
                        // replace the matched pattern with the mention attributed string
                        attributedString.replaceCharacters(in: matchRange, with: mentionAttributedString)
                    }
                }
            }
                
            catch {
                print("An error occurred attempting to locate pattern: " +
                    "\(error.localizedDescription)")
            }
        }
        
        // set attributed text
        return attributedString
        
    }
}
