//
//  Pickable.swift
//  JNMentionTextView_Example
//
//  Created by mihmouda on 6/2/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

/// Pickable protocol
public protocol JNMentionEntityPickable {
    
    /**
     Get Pickable title
     - Returns: The pickable title text.
     */
    func getPickableTitle() -> String
    
    /**
     Get Pickable Identifier
     - Returns: The pickable Identifier string.
     */
    func getPickableIdentifier() -> String
}
