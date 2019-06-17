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

/// JNMentionOptions
public struct JNMentionOptions {
    
    /// Border Color
    var borderColor: UIColor
    
    /// Border Width
    var borderWitdth: CGFloat
    
    /// Background Color
    var backgroundColor: UIColor
    
    /// List View Background Color
    var listViewBackgroundColor: UIColor

    /// View Mode
    var viewMode: JNMentionPickerViePositionwMode
    
    /// Mention Replacements
    var mentionReplacements: [String: [NSAttributedString.Key : Any]]
    
    /**
     Initializer
     - Parameter borderColor: Border color.
     - Parameter borderWitdth: Border width value.
     - Parameter backgroundColor: Background color.
     - Parameter listViewBackgroundColor: List view background color.
     - Parameter viewMode: JNMention View Mode.
     - Parameter mentionReplacements: array of JNMentionReplacement objects.
     */
    public init(borderColor: UIColor = .clear, borderWitdth: CGFloat = 0.0, backgroundColor: UIColor, listViewBackgroundColor: UIColor, viewMode: JNMentionPickerViePositionwMode, mentionReplacements: [String: [NSAttributedString.Key: Any]]) {
        
        // borderColor
        self.borderColor = borderColor
        
        // borderWitdth
        self.borderWitdth = borderWitdth
        
        // background Color
        self.backgroundColor = backgroundColor
        
        // list view background color
        self.listViewBackgroundColor = listViewBackgroundColor
        
        // view mode
        self.viewMode = viewMode
        
        // replacements
        self.mentionReplacements = mentionReplacements
    }
}
