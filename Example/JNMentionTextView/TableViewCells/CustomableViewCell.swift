//
//  TextFieldTableViewCell.swift
//  harriEmployer
//
//  Created by Ali Hamad on 5/30/18.
//  Copyright © 2018 Harri. All rights reserved.
//

import UIKit

/// Custom Table View Cell
class CustomableViewCell: UITableViewCell {
    
    /// Text Field
    @IBOutlet private weak var titleLabel: UILabel!
    
    /**
     Setup cell
     - Parameter representable: Text field table view cell representable
     - Parameter index: The cell index path
     - Parameter containerViewInsets: The Container View Insets
     - Parameter textFieldInsets: The text field view Insets
     - Parameter cornerRadious: Corner Radious.
     */
    func setup(title: String) {
        
        self.titleLabel.text = title
    }
  
    /**
     Register cell class in the table
     - Parameter tableView : The table view to register the cell in it
     */
    class func registerCell(in tableView: UITableView) {
        tableView.register(UINib(nibName: "CustomableViewCell", bundle: Bundle.main), forCellReuseIdentifier: CustomableViewCell.getReuseIdentifier())
    }
    
    /**
     Get cell reuse identifier
     - Returns: Cell reuse identifier
     */
    class func getReuseIdentifier() -> String {
        return "CustomableViewCell"
    }
    
    /**
     Get Cell Height
     - Returns : Cell height
     */
    class func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
}
