//
//  JNMentionTextView+PickerView.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// Picker View
extension JNMentionTextView {
    
    /**
     Init Picker View
     */
    func initPickerView() {
        
        self.pickerView = JNMentionPickerView(frame: self.frame)
        self.pickerView.setup(options: self.options)
    }
    
    /**
     Update Picker View Frame
     - Parameter selectedRange: Selected Range.
     */
    func updatePickerViewFrame(selectedRange: NSRange) {
        
        // get position in text view
        let rect: CGRect = self.caretRect(for: self.selectedTextRange?.start ?? self.beginningOfDocument)
                
        DispatchQueue.main.async {
            
            // make the table view height equal to content height
            self.pickerView.frame.size.height = self.pickerView.tableView.contentSize.height
            
            var originY: CGFloat = 0
            let contentOffset = self.contentOffset

            switch self.options.viewPositionMode {
                
                case .bottom(let accessoryView):
                    
                    originY = self.frame.origin.y + rect.origin.y + rect.height - contentOffset.y
                    
                    switch accessoryView {
                    case .triangle(let length):
                        self.pickerView.frame.size.height += (length * CGFloat(3.0.squareRoot())) / 2.0
                    case .none:
                        break
                    }
                
                case .top(let accessoryView):
                    
                    originY = self.frame.origin.y + rect.origin.y  - contentOffset.y - self.pickerView.frame.size.height
                    
                    switch accessoryView {
                    case .triangle(let length):
                        
                        let accessoryHeight = length * CGFloat(3.0.squareRoot()) / 2.0
                        
                        self.pickerView.frame.size.height += accessoryHeight
                        originY -= accessoryHeight
                    case .none:
                        break
               }
            }
            
            // update picker view y origin
            self.pickerView.frame.origin.y = ceil(originY)
        }
    }
    
}
