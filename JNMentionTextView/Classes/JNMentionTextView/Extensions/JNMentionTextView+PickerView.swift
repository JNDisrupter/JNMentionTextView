//
//  JNMentionTextView+PickerView.swift
//  JNMentionTextView_Example
//
//  Created by mihmouda on 6/2/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
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
    func uppdatePickerViewFrame(selectedRange: NSRange) {
        
        // get position in text view
        let beginning: UITextPosition? = self.beginningOfDocument
        let start: UITextPosition? = self.position(from: beginning!, offset: selectedRange.location)
        let end: UITextPosition? = self.position(from: start!, offset: selectedRange.length)
        let textRange: UITextRange? = self.textRange(from: start!, to: end!)
        let rect: CGRect = self.firstRect(for: textRange!)
        
        // get font size
        var fontSize = CGSize.zero
        if let font = self.options.normalAttributes[.font] as? UIFont {
            fontSize = CGSize(width: font.pointSize, height: font.pointSize)
        }
        
        DispatchQueue.main.async {
            
            // make the table view height equal to content height
            self.pickerView.frame.size.height = self.pickerView.tableView.contentSize.height
            
            var originY: CGFloat = 0
            let contentOffset = self.contentOffset

            switch self.options.viewMode {
                
                case .bottom(let accessoryView):
                    
                    originY = self.frame.origin.y + rect.origin.y + 10.0 + fontSize.height - contentOffset.y
                    
                    switch accessoryView {
                    case .triangle(let length):
                        self.pickerView.frame.size.height += (length * CGFloat(3.0.squareRoot())) / 2.0
                    case .plain:
                        break
                    }
                
                case .top(let accessoryView):
                    
                    originY = self.frame.origin.y + rect.origin.y - contentOffset.y - self.pickerView.frame.size.height
                    
                    switch accessoryView {
                    case .triangle(let length):
                        
                        let accessoryHeight = length * CGFloat(3.0.squareRoot()) / 2.0
                        
                        self.pickerView.frame.size.height += accessoryHeight
                        originY -= accessoryHeight
                    case .plain:
                        break
               }
            }
            
            // update picker view y origin
            self.pickerView.frame.origin.y = originY
            
            // redraw the triangle
            let difference = rect.origin.x + rect.width
            self.pickerView.drawTriangle(options: self.options, cursorOffset: difference)
        }
    }
    
}
