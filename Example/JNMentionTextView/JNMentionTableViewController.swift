//
//  JNMentionTableViewController.swift
//  JNMentionTextView_Example
//
//  Created by JNDisrupter 💡 on 6/25/19.
//  Copyright © 2019 JNDisrupter. All rights reserved.
//

import UIKit
import JNMentionTextView


// JNMentionTableViewController
class JNMentionTableViewController: UIViewController {
    
    /// Table View
    @IBOutlet weak var tableView: UITableView!
    
    /**
     View Did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // set navigation controller title
        self.navigationItem.title = "JN Mention TextView Examples"
    }
}

/// UITableViewDataSource, UITableViewDelegate
extension JNMentionTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != 20 {
            return UITableViewCell()
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "JNMentionTextViewTableViewCell", for: indexPath) as! JNMentionTextViewTableViewCell
            cell.parentViewController = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 20 {
            return 50.0
        } else {
            return JNMentionTextViewTableViewCell.getCellHeight()
        }
    }
}
