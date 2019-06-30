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
    case customCell
    case tableView

    // position mode
    var positionMode: JNMentionPickerViewPositionwMode {
        
        switch self {
        case .up:
            return JNMentionPickerViewPositionwMode.up
        case .bottom:
            return JNMentionPickerViewPositionwMode.down
        case .customCell:
            return JNMentionPickerViewPositionwMode.automatic
        case .tableView:
            return [JNMentionPickerViewPositionwMode.up, JNMentionPickerViewPositionwMode.down]
        }
    }
}

// JNMentionTextViewTableViewController
class JNMentionTextViewTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set navigation controller title
        self.navigationItem.title = "JN Mention TextView Examples"
    }
}
