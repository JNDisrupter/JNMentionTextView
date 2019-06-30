//
//  JNMentionTableViewController.swift
//  JNMentionTextView_Example
//
//  Created by JNDisrupter 💡 on 6/25/19.
//  Copyright © 2019 JNDisrupter. All rights reserved.
//

import UIKit
import JNMentionTextView

/// ComponentValues
private struct ComponentValues {
    static let cellHeight: CGFloat = 100.0
}

// JNMentionTableViewController
class JNMentionTableViewController: UIViewController {
    
    /// Table View
    @IBOutlet weak var tableView: UITableView!
    
    /**
     View Did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // empty back title
        self.navigationController?.navigationBar.topItem?.title = " "
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

/// UITableViewDataSource, UITableViewDelegate
extension JNMentionTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != 5 {
            
            let cell = UITableViewCell()
            cell.textLabel?.text = " Cell # " + indexPath.row.description
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "JNMentionTextViewTableViewCell", for: indexPath) as! JNMentionTextViewTableViewCell
            cell.parentViewController = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 5 {
            return ComponentValues.cellHeight
        } else {
            return JNMentionTextViewTableViewCell.getCellHeight()
        }
    }
}
