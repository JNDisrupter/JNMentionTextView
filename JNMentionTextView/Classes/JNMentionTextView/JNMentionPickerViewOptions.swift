//
//  JNMentionOptions.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// JNMention Picker View Position Mode
public enum JNMentionPickerViePositionwMode {
    
    /// Top
    case top(JNMentionPickerViePositionwMode.accessoryView)
    
    /// Bottom
    case bottom(JNMentionPickerViePositionwMode.accessoryView)
    
    /// Accessory View
    public enum accessoryView {
        
        /// None
        case none
        
        /// Triangle
        case triangle(sideLength: CGFloat)
    }
}

/// JNMention Picker View Options
public struct JNMentionPickerViewOptions {
    
    /// Border Color
    var borderColor: UIColor
    
    /// Border Width
    var borderWitdth: CGFloat
    
    /// Background Color
    var backgroundColor: UIColor
    
    /// View Position Mode
    var viewPositionMode: JNMentionPickerViePositionwMode
        
    /**
     Initializer
     - Parameter borderColor: Border color.
     - Parameter borderWitdth: Border width value.
     - Parameter backgroundColor: Background color.
     - Parameter viewPositionMode: JNMention View Mode.
     */
    public init(borderColor: UIColor = .clear, borderWitdth: CGFloat = 0.0, backgroundColor: UIColor = UIColor.white, viewPositionMode: JNMentionPickerViePositionwMode) {
        
        // borderColor
        self.borderColor = borderColor
        
        // borderWitdth
        self.borderWitdth = borderWitdth
        
        // background Color
        self.backgroundColor = backgroundColor
        
        // view position mode
        self.viewPositionMode = viewPositionMode
    }
}
