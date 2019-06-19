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
        
        // unhide the picker view
        self.pickerView.isHidden = false
    }
    
    /**
     End Mention Process
     */
    func endMentionProcess() {
        
        self.searchString = ""
        self.selectedSymbol = ""
        self.selectedSymbolLocation = 0
        self.selectedSymbolAttributes = [:]
        self.pickerView.isHidden = true
        
        self.resetConentOffset()
    }
    
    func resetConentOffset(){
        
        DispatchQueue.main.async {
            self.setContentOffset(self.previousOffset, animated: false)
        }
    }
    
    /**
     Apply Mention Engine
     - Parameter searchRange: NSRange.
     */
    func applyMentionEngine(searchRange: NSRange) {
        
        // in mention process
        guard !self.isInFilterProcess() else { return }
        
        // iterate through each replacement symbol
        for (pattern, attributes) in self.mentionReplacements {
            
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
                        
                       self.postFilteringProcess(in: matchRange, completion: { [weak self] in
                        
                        guard let strongSelf = self else { return }
                        let rect: CGRect = strongSelf.caretRect(for: strongSelf.selectedTextRange?.start ?? strongSelf.beginningOfDocument)
                        
                        
                        strongSelf.pickerView.drawTriangle(options: strongSelf.options, cursorOffset: rect.origin.x + rect.width)
                        
                        strongSelf.previousOffset = CGPoint(x: 0.0, y: strongSelf.contentOffset.y)
                        
                        
                        let textPosition = strongSelf.position(from: strongSelf.beginningOfDocument, offset: strongSelf.selectedRange.location) ?? strongSelf.beginningOfDocument

                        let conentOffsetRect = strongSelf.caretRect(for: textPosition)

                        DispatchQueue.main.async {
                            
                            
                            switch strongSelf.options.viewPositionMode {
                                
                            case .top(_):
                                
                                strongSelf.setContentOffset(CGPoint(x: strongSelf.contentOffset.x, y: conentOffsetRect.origin.y - strongSelf.bounds.size.height + conentOffsetRect.size.height), animated: false)
                                
                            case .bottom(_):
                                
                                strongSelf.setContentOffset(CGPoint(x: strongSelf.contentOffset.x, y: conentOffsetRect.origin.y), animated: false)

                            }
                        }
                        
                       })
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
