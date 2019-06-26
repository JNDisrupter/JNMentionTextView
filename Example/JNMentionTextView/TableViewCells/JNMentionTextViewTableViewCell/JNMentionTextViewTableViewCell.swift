//
//  JNMentionTextViewTableViewCell.swift
//  JNMentionTextView_Example
//
//  Created by JNDisrupter 💡 on 6/25/19.
//  Copyright © 2019 JNDisrupter. All rights reserved.
//

import UIKit
import JNMentionTextView

/// JNMentionTextViewTableViewCell
class JNMentionTextViewTableViewCell: UITableViewCell {
    
    /// Text View
    @IBOutlet weak var textView: JNMentionTextView!
    
    /// Data
    var data: [String: [JNMentionPickable]] = [:]
    
    /// Parent View Controller
    var parentViewController: UIViewController!
    
    /**
     Awake From Nib
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set Selection Style
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        // customize text view apperance
        self.textView.font = UIFont.systemFont(ofSize: 17.0)
        
        // set text view mention replacements
        self.textView.mentionReplacements = ["@": [NSAttributedString.Key.foregroundColor: UIColor.blue,
                                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)], "#": [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]]
        
        // init options
        let options = JNMentionPickerViewOptions(viewPositionMode: JNMentionPickerViewPositionwMode.automatic)
        
        
        // build data
        let firstUser  = User(id: 1,
                              name: "Tom Hanks",
                              details: "American actor and filmmaker",
                              imageName: "tom_hanks")
        
        let secondUser = User(id: 2,
                              name: "Leonardo DiCaprio",
                              details: "American actor and filmmaker",
                              imageName: "leonardo_diCaprio")
        
        let thirdUser  = User(id: 3,
                              name: "Morgan Freeman",
                              details: "American actor and filmmaker",
                              imageName: "morgan_freeman")
        
        let fourthUser = User(id: 4,
                              name: "Samuel L. Jackson",
                              details: "American actor and filmmaker",
                              imageName: "samuel_l_jackson")
        
        let fifthUser  = User(id: 5,
                              name: "Tom Cruise",
                              details: "American actor and filmmaker",
                              imageName: "tom_cruise")
        
        // set data
        self.data = ["@": [firstUser, secondUser, thirdUser], "#": [fourthUser, fifthUser]]
        
        // etup text view
        self.textView.returnKeyType = .done
        
        // etup text view
        self.textView.setup(options: options)
        
        // set mention delegate
        self.textView.mentionDelegate = self
    }
   
    
    /**
     Register cell class in the table
     - Parameter tableView : The table view to register the cell in it
     */
    class func registerCell(in tableView: UITableView) {
        tableView.register(UINib(nibName: "JNMentionTextViewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: JNMentionTextViewTableViewCell.getReuseIdentifier())
    }
    
    /**
     Get cell reuse identifier
     - Returns: Cell reuse identifier
     */
    class func getReuseIdentifier() -> String {
        return "JNMentionTextViewTableViewCell"
    }
    
    /**
     Get Cell Height
     - Returns : Cell height
     */
    class func getCellHeight() -> CGFloat {
        return 120.0
    }
}

/// JNMentionTextViewDelegate
extension JNMentionTextViewTableViewCell: JNMentionTextViewDelegate {
    
    /**
     Get Mention Item For
     - Parameter symbol: replacement string.
     - Parameter id: JNMentionEntityPickable ID.
     - Returns: JNMentionEntityPickable object for the search criteria.
     */
    func jnMentionTextView(getMentionItemFor symbol: String, id: String) -> JNMentionPickable? {
        
        for item in self.data[symbol] ?? [] {
            if item.getPickableIdentifier() == id {
                return item
            }
        }
        
        return nil
    }
    
    /**
     Retrieve Data For
     - Parameter symbole: replacement string.
     - Parameter searchString: search string.
     - Returns: list of JNMentionEntityPickable objects for the search criteria.
     */
    func jnMentionTextView(retrieveDataFor symbol: String, using searchString: String) -> [JNMentionPickable] {
        
        var data = self.data[symbol] ?? []
        if !searchString.isEmpty {
            data = data.filter({ $0.getPickableTitle().lowercased().contains(searchString.lowercased())})
        }
        
        return data
    }
    
    /**
     Frame at
     - Parameter indexPath: IndexPath.
     - Returns frame: view frame.
     */
    func jnMentionTextViewFrame(at indexPath: IndexPath?) -> CGRect {
        return self.textView.frame
    }
    
    /**
     Source View For Picker View
     - Returns: the super view for the picker view.
     */
    func sourceViewControllerForPickerView() -> UIViewController {
        return self.parentViewController
    }
    
    /**
     height for picker view
     - Returns: picker view height.
     */
    func heightForPickerView() -> CGFloat {
        return 200.0
    }
}
