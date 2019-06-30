//
//  CustomTableViewCell.swift
//  JNMentionTextView_Example
//
//  Created by JNDisrupter 💡 on 6/25/19.
//  Copyright © 2019 JNDisrupter. All rights reserved.
//

import UIKit
import JNMentionTextView

/// Custom Table View Cell
class CustomTableViewCell: UITableViewCell {
    
    /// Title Label
    @IBOutlet private weak var nameLabel: UILabel!
    
    /// Details Label
    @IBOutlet private weak var detailsLabel: UILabel!
    
    /// Avatar Image view
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    /// Avatar Container View
    @IBOutlet private weak var avatarContainerView: UIView!

    /// Data
    var data: [String: [JNMentionPickable]] = [:]
    
    /**
     Awake From Nib
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set Selection Style
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.borderColor = UIColor.blue.cgColor
        self.avatarImageView.layer.borderWidth = 1.0
    }
    
    /**
     Layout Subviews
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2.0
        self.avatarContainerView.layer.cornerRadius = self.avatarImageView.frame.width / 2.0
        self.avatarContainerView.layer.shadowColor = UIColor.black.cgColor
        self.avatarContainerView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        self.avatarContainerView.layer.shadowOpacity = 0.4
        self.avatarContainerView.layer.shadowRadius = 2
    }
    
    /**
     Setup cell
     - Parameter representable: Text field table view cell representable
     - Parameter index: The cell index path
     - Parameter containerViewInsets: The Container View Insets
     - Parameter textFieldInsets: The text field view Insets
     - Parameter cornerRadious: Corner Radious.
     */
    func setup(user: User) {
        
        self.nameLabel.text = user.name
        self.detailsLabel.text = user.details
        self.avatarImageView.image = UIImage(named: user.imageName)
    }
    
    /**
     Register cell class in the table
     - Parameter tableView : The table view to register the cell in it
     */
    class func registerCell(in tableView: UITableView) {
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: CustomTableViewCell.getReuseIdentifier())
    }
    
    /**
     Get cell reuse identifier
     - Returns: Cell reuse identifier
     */
    class func getReuseIdentifier() -> String {
        return "CustomTableViewCell"
    }
    
    /**
     Get Cell Height
     - Returns : Cell height
     */
    class func getCellHeight() -> CGFloat {
        return 75.0
    }
}
