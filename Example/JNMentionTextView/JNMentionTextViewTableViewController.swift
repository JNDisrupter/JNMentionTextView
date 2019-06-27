//
//  JNMentionTextViewTableViewController.swift
//  JNMentionTextView_Example
//
//  Created by JNDisrupter 💡 on 6/25/19.
//  Copyright © 2019 JNDisrupter. All rights reserved.
//

import UIKit
import JNMentionTextView

// JNMentionTextViewExample
enum JNMentionTextViewExample: Int {
    
    case up
    case bottom
    case automatic
    case customCell
    case tableView

    // position mode
    var positionMode: JNMentionPickerViewPositionwMode {
        
        switch self {
        case .up:
            return JNMentionPickerViewPositionwMode.up
        case .bottom:
            return JNMentionPickerViewPositionwMode.down
        case .automatic:
            return [JNMentionPickerViewPositionwMode.up, JNMentionPickerViewPositionwMode.down]
        case .customCell:
            return JNMentionPickerViewPositionwMode.up
        case .tableView:
            return [JNMentionPickerViewPositionwMode.up, JNMentionPickerViewPositionwMode.down]
        }
    }
}

// JNMentionTextViewTableViewController
class JNMentionTextViewTableViewController: UITableViewController {
    
    /**
     View Did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation controller title
        self.navigationItem.title = "JN Mention TextView Examples"
    }
}
