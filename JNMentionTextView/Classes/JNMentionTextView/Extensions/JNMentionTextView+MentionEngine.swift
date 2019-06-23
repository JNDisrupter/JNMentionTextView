//
//  JNMentionTextView+MentionEngine.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// MentionEngine
extension JNMentionTextView: UIPopoverPresentationControllerDelegate {
    
    /**
     Start Mention Process
     */
    func startMentionProcess() {
        
        if self.pickerViewController == nil {
            self.pickerViewController = JNMentionPickerViewController()
            pickerViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            pickerViewController.preferredContentSize = CGSize(width: self.frame.size.width , height: 100)
            pickerViewController.options = self.options
            pickerViewController.delegate = self
            
            let popoverPresentationController = pickerViewController.popoverPresentationController
            popoverPresentationController?.delegate = self
            popoverPresentationController?.sourceView = self
            popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            popoverPresentationController?.containerView?.backgroundColor = UIColor.red
            popoverPresentationController?.presentedView?.backgroundColor = UIColor.red
            popoverPresentationController?.backgroundColor = UIColor.yellow
            popoverPresentationController?.containerView?.layer.borderColor = UIColor.red.cgColor
            popoverPresentationController?.popoverBackgroundViewClass = MyPopoverBackgroundView.self
        }

        if let viewcontroller = self.mentionDelegate?.sourceViewForPickerView() {
            let rect: CGRect = self.caretRect(for: self.selectedTextRange?.start ?? self.beginningOfDocument)
            let popoverPresentationController = self.pickerViewController.popoverPresentationController
            popoverPresentationController?.sourceRect = rect
            //popoverPresentationController?.passthroughViews = [self]
            viewcontroller.present(self.pickerViewController, animated: true, completion:{
                
            })
            
        }
        
//        // unhide the picker view
//        self.pickerView.isHidden = false
//
//        // super view
//        var superView = self.superview
//
//        switch self.options.viewPositionMode {
//        case .top(_), .bottom(_):
//            superView = self.mentionDelegate?.sourceViewForPickerView() ?? self.superview
//        default:
//            break
//        }
//
//        if self.pickerView.superview != superView {
//
//            // remove picker view from super view
//            self.pickerView.removeFromSuperview()
//
//            // add picker view
//            superView?.addSubview(self.pickerView)
//        }
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    /**
     End Mention Process
     */
    func endMentionProcess() {
        
        self.searchString = ""
        self.selectedSymbol = ""
        self.selectedSymbolLocation = 0
        self.selectedSymbolAttributes = [:]
       // self.pickerView.isHidden = true
        //self.pickerViewController.dismiss(animated: true, completion: nil)
        self.resetConentOffset()
    }
    
    /**
     Set content offset on
     - Parameter position: UITextPosition.
     */
    func setContentOffset() {
        
//        // get text position
//        let textPosition = self.position(from: self.beginningOfDocument, offset: self.selectedRange.location) ?? self.beginningOfDocument
//
//        // content offset
//        let conentOffsetRect = self.caretRect(for: textPosition)
//
//        DispatchQueue.main.async {
//
//            // scroll to content offset accroding to view position mode
//            switch self.options.viewPositionMode {
//
//            case .top(_), .enclosedTop(_):
//                self.setContentOffset(CGPoint(x: self.contentOffset.x, y: conentOffsetRect.origin.y - self.bounds.size.height + conentOffsetRect.size.height), animated: false)
//            case .bottom(_), .enclosedBottom(_):
//                self.setContentOffset(CGPoint(x: self.contentOffset.x, y: conentOffsetRect.origin.y), animated: false)
//            }
//        }
    }
    
    /**
     Reset Content Offset
     */
    func resetConentOffset(){
//        
//        DispatchQueue.main.async {
//            self.setContentOffset(self.previousOffset, animated: false)
//        }
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
                        
                        // post filtering process
                        self.postFilteringProcess(in: matchRange, completion: { [weak self] in
                            
//                            // strong self
//                            guard let strongSelf = self else { return }
//
//                            // create CGRect for current position
//                            let rect: CGRect = strongSelf.caretRect(for: strongSelf.selectedTextRange?.start ?? strongSelf.beginningOfDocument)
//
//                            // draw triangle in current position
//                            //strongSelf.pickerView.drawTriangle(options: strongSelf.options, cursorOffset: rect.origin.x + rect.width)
//
//                            // save previous offset
//                            strongSelf.previousOffset = CGPoint(x: 0.0, y: strongSelf.contentOffset.y)
//
//                            // set content offset
//                            strongSelf.setContentOffset()
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
