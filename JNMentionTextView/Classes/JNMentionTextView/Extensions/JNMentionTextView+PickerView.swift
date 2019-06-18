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
                var originY: CGFloat = 0.0
        var height = self.frame.height - rect.height - 10.0
 
        switch self.options.viewPositionMode {
            
        case .bottom(let accessoryView):
            
            originY = rect.height
            
//            switch accessoryView {
//            case .triangle(let length):
//                height -= (length * CGFloat(3.0.squareRoot())) / 2.0
//            case .none:
//                break
//            }
            
        case .top(let accessoryView):
            
            originY = 0
            
//            switch accessoryView {
//            case .triangle(let length):
//                height += length * CGFloat(3.0.squareRoot()) / 2.0
//            case .none:
//                break
//            }
        }
        
        var pickerViewFrame = self.frame
//        pickerViewFrame.origin.y = originY
        pickerViewFrame.size.height = height
        
        self.pickerView.frame = pickerViewFrame
        
            completion?()
    }
    
}
