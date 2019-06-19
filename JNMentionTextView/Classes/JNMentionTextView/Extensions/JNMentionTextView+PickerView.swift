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
        
        self.pickerView = JNMentionPickerView(frame: CGRect.zero)

        self.superview?.addSubview(self.pickerView)
        self.pickerView.setup(options: self.options)
        
    }
    
    /**
     Set Picker View Frame
     */
    func setPickerViewFrame(completion:(() -> ())? = nil) {
        
        // get position in text view
        let rect: CGRect = self.caretRect(for: self.selectedTextRange?.start ?? self.beginningOfDocument)
        
        var originY: CGFloat = self.frame.origin.y
        let height = self.frame.height - rect.height - 10.0
 
        switch self.options.viewPositionMode {
            
        case .bottom(_):
            originY += rect.height
        default:
            break
        }
        
        var pickerViewFrame = self.frame
        pickerViewFrame.size.height = height
        pickerViewFrame.origin.y = originY
        self.pickerView.frame = pickerViewFrame
        
            completion?()
    }
    
}
