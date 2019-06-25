//
//  JNMentionTextViewTableViewController+DataSource.swift
//  JNMentionTextView_Example
//
//  Created by JNDisrupter 💡 on 6/25/19.
//  Copyright © 2019 JNDisrupter. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate
extension JNMentionTextViewTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if JNMentionTextViewExample(rawValue: indexPath.row) == .customCell {
            self.performSegue(withIdentifier: "showCustomCellMention", sender: indexPath.row)
        } else if JNMentionTextViewExample(rawValue: indexPath.row) == .tableView {
            self.performSegue(withIdentifier: "showTableCellMention", sender: indexPath.row)
        } else {
            self.performSegue(withIdentifier: "showDefaultCellMention", sender: indexPath.row)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let sender = sender as? Int, let example = JNMentionTextViewExample(rawValue: sender)
            else { return }
        
        if segue.identifier == "showCustomCellMention"  {
            
            if let destinationVC = segue.destination as? JNMentionCustomCellViewController {
                destinationVC.positionMode = example.positionMode
            }
            
        } else {
            
            if let destinationVC = segue.destination as? JNMentionViewController {
                destinationVC.positionMode = example.positionMode
            }
        }
    }
}
