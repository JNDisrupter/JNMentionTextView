//
//  JNMentionTextView+UITextViewDelegate.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// UITextViewDelegate
extension JNMentionTextView: UITextViewDelegate {
    
    /**
     Should Change Text In
     */
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // return if delegate indicate that it sohuld not chnage text in the selected range.
        if let delegate = self.mentionDelegate, !(delegate.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true) {
            return false
        }
        
        // ShouldChangeText
        var shouldChangeText = true
        
        // In Filter Process
        if self.isInFilterProcess() {
            
            // delete text
            if text.isEmpty {
                
                // delete the special symbol string
                if range.location == self.selectedSymbolLocation {
                    
                    // end mention process
                    self.endMentionProcess()
                    
                } else {
                    
                    // deleted index
                    let deletedIndex = range.location - self.selectedSymbolLocation - 1
                    
                    // deleted index greter than 0
                    guard deletedIndex > 0
                        else {
                            self.endMentionProcess()
                            return true
                    }
                    
                    let index = self.searchString.index(self.searchString.startIndex, offsetBy: deletedIndex)
                    self.searchString.remove(at: index)
                 }

            } else {
                self.searchString += text
            }
            
            // Calculate range
            let filterRange = NSRange(location: range.location - self.searchString.count , length: self.searchString.count)            
            self.postFilteringProcess(in: filterRange, completion: {
                
                // end mention process
                if self.pickerView.tableView.visibleCells.count == 0 {
                    self.endMentionProcess()
                }
            })
            
            
        } else {
            
            // check if delete already mentioned item
            if let selectedRange = self.selectedTextRange {
                
                // cursor position
                let cursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
                guard cursorPosition > 0 else { return true }
                
                // iterate through all range
                self.attributedText.enumerateAttributes(in: NSRange(0..<self.textStorage.length), options: []) { (attributes, rangeAttributes, stop) in
                    
                    // get value for JNMentionNSAttribute
                    if let mentionedItem = attributes[JNMentionTextView.JNMentionAttributeName] as? JNMentionEntity,
                        cursorPosition > rangeAttributes.location && (text.isEmpty ? cursorPosition - 1 : cursorPosition) <= rangeAttributes.location + rangeAttributes.length {
                        
                        // init replacement string
                        let replacementString = mentionedItem.symbol + mentionedItem.item.getPickableTitle()
                        
                        // replace the mentioned item with (symbol with mentioned title)
                        self.textStorage.replaceCharacters(in: rangeAttributes, with: NSAttributedString(string: replacementString, attributes: self.normalAttributes))
                        
                        // move cursor to the end of replacement string
                        self.moveCursor(to: rangeAttributes.location + replacementString.count)
                        
                        // set selected symbol information
                        self.selectedSymbol = mentionedItem.symbol
                        self.selectedSymbolLocation = rangeAttributes.location
                        self.selectedSymbolAttributes = attributes
                        
                        // start mention process with search string for item title
                        self.searchString = mentionedItem.item.getPickableTitle()
                        self.startMentionProcess()
                        
                        // post filtering process
                        self.postFilteringProcess(in: rangeAttributes, completion: { [weak self] in
                            
                            // strong self
                            guard let strongSelf = self else { return }
                            
                            // get position
                            let position = strongSelf.position(from: strongSelf.beginningOfDocument, offset: strongSelf.selectedSymbolLocation)
                            
                            // create CGRect for current position
                            let rect: CGRect = strongSelf.caretRect(for: position ?? strongSelf.beginningOfDocument)
                            
                            // draw triangle in current position
                            strongSelf.pickerView.drawTriangle(options: strongSelf.options, cursorOffset: rect.origin.x + rect.width)
                            
                            // save previous offset
                            strongSelf.previousOffset = CGPoint(x: 0.0, y: strongSelf.contentOffset.y)
                            
                            // set content offset
                            strongSelf.setContentOffset()
                        })
                        
                        
                        // skip this change in text
                        shouldChangeText = false
                    }
                }
            }
            
            // set normal attributes
            if !text.isEmpty {
             self.normalAttributes = self.typingAttributes
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
        
        // call delegate
        self.mentionDelegate?.textViewDidChange?(textView)
    }
    
    /**
     Text View should begin editing
     */
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.mentionDelegate?.textViewShouldBeginEditing?(textView) ?? true
    }
    
    /**
     Text View should end editing
     */
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return self.mentionDelegate?.textViewShouldEndEditing?(textView) ?? true
    }
    
    /**
     Text View Did begin editing
     */
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.mentionDelegate?.textViewDidBeginEditing?(textView)
    }
    
    /**
     Text View Did end editing
     */
    public func textViewDidEndEditing(_ textView: UITextView) {
        
        // end mention process
        self.endMentionProcess()
        self.mentionDelegate?.textViewDidEndEditing?(textView)
    }
    
    /**
     Text View did change selection
     */
    public func textViewDidChangeSelection(_ textView: UITextView) {
        self.mentionDelegate?.textViewDidChangeSelection?(textView)
    }
    
    /**
     Text View should interact with url.
     */
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return self.mentionDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange) ?? true
    }
    
    /**
     Text View should interact with url in range with interaction.
     */
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.mentionDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
    
    /**
     Text View should interact with text attachment in range with interaction.
     */
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.mentionDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
    
    /**
     Text View should interact with text attachment in range.
     */
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return self.mentionDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange) ?? true
    }
}
