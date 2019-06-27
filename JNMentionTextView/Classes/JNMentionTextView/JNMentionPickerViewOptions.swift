//
//  JNMentionOptions.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// JNMention Picker View Position Mode
public struct JNMentionPickerViewPositionwMode: OptionSet {
    
    /// Raw Value
    public var rawValue: UInt
    
    /**
     Init With rawValue
     - Paramerter rawValue: Raw Value.
     */
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    /// Picker View Positionw Mode Up
    public static let up = JNMentionPickerViewPositionwMode(rawValue: 0)
    
    /// Picker View Positionw Mode Down
    public static let down = JNMentionPickerViewPositionwMode(rawValue: 1)
    
    /// Picker View Positionw Mode automatic
    public static let automatic = JNMentionPickerViewPositionwMode(rawValue: 2)
}

/// JNMention Picker View Options
public struct JNMentionPickerViewOptions {
    
    /// Background Color
    var backgroundColor: UIColor
    
    /// View Position Mode
    var viewPositionMode: JNMentionPickerViewPositionwMode
        
    /**
     Initializer
     - Parameter backgroundColor: Background color.
     - Parameter viewPositionMode: JNMention View Mode.
     */
    public init(backgroundColor: UIColor = UIColor.white, viewPositionMode: JNMentionPickerViewPositionwMode) {
        
        // background Color
        self.backgroundColor = backgroundColor
        
        // view position mode
        self.viewPositionMode = viewPositionMode
    }
}
