//
//  JNMentionOptions.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// JNMention Picker View Position Mode
public struct JNMentionPickerViewPositionwMode: OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let up = JNMentionPickerViewPositionwMode(rawValue: 0)
    public static let down = JNMentionPickerViewPositionwMode(rawValue: 1)
    public static let automatic = JNMentionPickerViewPositionwMode(rawValue: 2)
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
    var viewPositionMode: JNMentionPickerViewPositionwMode
        
    /**
     Initializer
     - Parameter borderColor: Border color.
     - Parameter borderWitdth: Border width value.
     - Parameter backgroundColor: Background color.
     - Parameter viewPositionMode: JNMention View Mode.
     */
    public init(borderColor: UIColor = .clear, borderWitdth: CGFloat = 0.0, backgroundColor: UIColor = UIColor.white, viewPositionMode: JNMentionPickerViewPositionwMode) {
        
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
