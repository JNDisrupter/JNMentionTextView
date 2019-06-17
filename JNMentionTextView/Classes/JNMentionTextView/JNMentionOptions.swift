//
//  JNMentionOptions.swift
//  JNMentionTextView_Example
//
//  Created by mihmouda on 6/2/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

/// JNMention View Mode
public enum JNMentionViewMode {
    
    // Top
    case top(JNMentionViewMode.accessoryView)
    
    // Bottom
    case bottom(JNMentionViewMode.accessoryView)
    
    /// Accessory View
    public enum accessoryView {
        
        // Plain
        case plain
        
        // Triangle
        case triangle(length: CGFloat)
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
    var viewMode: JNMentionViewMode
    
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
    public init(borderColor: UIColor = .clear, borderWitdth: CGFloat = 0.0, backgroundColor: UIColor, listViewBackgroundColor: UIColor, viewMode: JNMentionViewMode, mentionReplacements: [String: [NSAttributedString.Key: Any]]) {
        
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
