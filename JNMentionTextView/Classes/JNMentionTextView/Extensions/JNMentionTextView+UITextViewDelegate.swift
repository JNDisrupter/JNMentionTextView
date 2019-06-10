//
//  JNMentionTextView+UITextViewDelegate.swift
//  JNMentionTextView_Example
//
//  Created by mihmouda on 6/2/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

/// UITextViewDelegate
extension JNMentionTextView: UITextViewDelegate {
    
    /**
     Should Change Text In
     */
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // ShouldChangeText
        var shouldChangeText = true
        
        // In Filter Process
        if self.isInFilterProcess() {
            
            // delete text
            if text.isEmpty {
                
                // delete the special symbol string
                if range.location == self.selectedSymbolLocation {
                    
                    // end mention process
                    self.searchString = ""
                    self.endMentionProcess()
                    
                } else {
                    
                    // deleted index
                    let deletedIndex = range.location - self.selectedSymbolLocation - 1
                    
                    let index = self.searchString.index(self.searchString.startIndex, offsetBy: deletedIndex)
                    self.searchString.remove(at: index)
                 }

            } else {
                self.searchString += text
            }
            
            // Calculate range
            let filterRange = NSRange(location: range.location - self.searchString.count , length: self.searchString.count)
            
            // post filter process
            self.postFilteringProcess(in: filterRange)
            
            
        } else {
            
            // check if delete already mentioned item
            if text.isEmpty {
                
                if let selectedRange = self.selectedTextRange {
                    
                    // cursor position
                    let cursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
                    guard cursorPosition > 0 else { return true }
                    
                    // iterate through all range
                    self.attributedText.enumerateAttributes(in: NSRange(0..<self.textStorage.length), options: []) { (attributes, rangeAttributes, stop) in
                        
                        // get value for JNMentionNSAttribute
                        if let mentionedItem = attributes[JNMentionTextView.JNMentionAttributeName] as? JNMentionEntity,
                            cursorPosition > rangeAttributes.location && cursorPosition <= rangeAttributes.location + rangeAttributes.length {
                            
                            // init replacement string
                            let replacementString = mentionedItem.symbol + mentionedItem.item.getPickableTitle()
                            
                            // replace the mentioned item with (symbol with mentioned title)
                            self.textStorage.replaceCharacters(in: rangeAttributes, with: NSAttributedString(string: replacementString, attributes: self.options.normalAttributes))
                            
                            // move cursor to the end of replacement string
                            self.moveCursor(to: rangeAttributes.location + replacementString.count)
                            
                            // set selected symbol information
                            self.selectedSymbol = mentionedItem.symbol
                            self.selectedSymbolLocation = rangeAttributes.location
                            self.selectedSymbolAttributes = attributes
                            
                            // start mention process with search string for item title
                            self.searchString = mentionedItem.item.getPickableTitle()
                            self.startMentionProcess()
                            self.postFilteringProcess(in: rangeAttributes)
                            
                            // skip this change in text
                            shouldChangeText = false
                        }
                    }
                }
            }
        }
        
        return shouldChangeText
    }
    
    /**
     Text View Did Change
     */
    open func textViewDidChange(_ textView: UITextView) {
        
        // calculate range
        let range = NSRange(location: 0, length: self.attributedText.string.count)
        self.applyMentionEngine(searchRange: range)
    }
}
