//
//  JNMentionTextView+MentionEngine.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// MentionEngine
extension JNMentionTextView {
    
    /**
     Start Mention Process
     */
    func startMentionProcess() {
        self.pickerView.isHidden = false
        
        // super view
        let superView = self.mentionDelegate?.superViewForPickerView()
        
        if self.pickerView.superview != superView {
            
            // remove picker view from super view
            self.pickerView.removeFromSuperview()
            
            // add picker view
            superView?.addSubview(self.pickerView)
        }

        // set picker view frame
        self.pickerView.frame.size.height = self.mentionDelegate?.heightForPickerView() ?? 0.0
    }
    
    /**
     End Mention Process
     */
    func endMentionProcess() {
        self.pickerView.isHidden = true
    }
    
    /**
     Apply Mention Engine
     - Parameter searchRange: NSRange.
     */
    func applyMentionEngine(searchRange: NSRange) {
        
        // in mention process
        guard !self.isInFilterProcess() else { return }
        
        // iterate through each replacement symbol
        for (pattern, attributes) in self.options?.mentionReplacements ?? [:] {
            
            do {
                let regex = try NSRegularExpression(pattern: pattern)
                regex.enumerateMatches(in: self.textStorage.string, range: searchRange) {
                    match, flags, stop in
                    
                    if var matchRange = match?.range(at: 0), let selectedRange = self.selectedTextRange {
                        
                        let cursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
                        guard cursorPosition > matchRange.location && cursorPosition <= matchRange.location + matchRange.length else { return }
                        
                        // update match range length
                        matchRange.length = cursorPosition - matchRange.location
                        
                        // set selected symbol information
                        self.selectedSymbol = String((self.textStorage.string as NSString).substring(with: matchRange).first ?? Character(""))
                        self.selectedSymbolLocation = matchRange.location
                        self.selectedSymbolAttributes = attributes

                        // start mention process
                        self.startMentionProcess()
                        self.postFilteringProcess(in: matchRange)
                        
                    }
                }
            }
                
            catch {
                print("An error occurred attempting to locate pattern: " +
                    "\(error.localizedDescription)")
            }
        }
    }
}
