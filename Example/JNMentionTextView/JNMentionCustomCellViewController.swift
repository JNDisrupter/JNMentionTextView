//
//  JNMentionCustomCellViewController.swift
//  JNMentionTextView_Example
//
//  Created by JNDisrupter 💡 on 6/25/19.
//  Copyright © 2019 JNDisrupter. All rights reserved.
//

import UIKit
import JNMentionTextView

/// JNMentionCustomCellViewController
class JNMentionCustomCellViewController: UIViewController {
    
    /// Text View
    @IBOutlet weak var textView: JNMentionTextView!
    
    /// position mode
    var positionMode: JNMentionPickerViewPositionwMode = JNMentionPickerViewPositionwMode.up
    
    /// Data
    var data: [String: [JNMentionPickable]] = [:]
    
    /**
     View Did Load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // empty back title
    self.navigationController?.navigationBar.topItem?.title = " "
        
        // customize text view apperance
        self.textView.font = UIFont.systemFont(ofSize: 17.0)
        
        // set text view mention replacements
        self.textView.mentionReplacements = ["@": [NSAttributedString.Key.foregroundColor: UIColor.blue,
                                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)], "#": [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]]
        
        // init options
        let options = JNMentionPickerViewOptions(viewPositionMode: self.positionMode)
        
        
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
        
        // register table view cells
        self.textView.registerTableViewCell(UINib(nibName: CustomTableViewCell.getReuseIdentifier(), bundle: Bundle.main), forCellReuseIdentifier: CustomTableViewCell.getReuseIdentifier())
        
    }
    
    
    /**
     Get Mentioned Items
     */
    @IBAction func getMentionedItems(_ sender: Any) {
        
        let items = JNMentionTextView.getMentionedItems(from: self.textView.attributedText, symbol: "@")
        print(items)
    }
    
    /**
     Set Smart Field
     */
    @IBAction func setSmartField(_ sender: Any) {
        
        let attributedString = JNMentionTextView.getSmartReplacement(text: "hi @1 and @2", data: self.data, normalAttributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)], mentionReplacements: ["@": [NSAttributedString.Key.foregroundColor: UIColor.blue,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]])
        
        self.textView.attributedText = attributedString
        
    }
}

/// JNMentionTextViewDelegate
extension JNMentionCustomCellViewController: JNMentionTextViewDelegate {

    /**
     Frame at
     - Parameter indexPath: IndexPath.
     - Returns frame: view frame.
     */
    func jnMentionTextViewFrame(at indexPath: IndexPath?) -> CGRect {
        return self.textView.frame
    }
    
    
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
     - Parameter symbol: replacement string.
     - Parameter searchString: search string.
     - Parameter compliation: list of JNMentionEntityPickable objects for the search criteria.
     */
    func jnMentionTextView(retrieveDataFor symbol: String, using searchString: String, compliation: (([JNMentionPickable]) -> ())) {
        
        var data = self.data[symbol] ?? []
        if !searchString.isEmpty {
            data = data.filter({ $0.getPickableTitle().lowercased().contains(searchString.lowercased())})
        }
        
        return compliation(data)
    }
    
    /**
     Source View For Picker View
     - Returns: the super view for the picker view.
     */
    func sourceViewControllerForPickerView() -> UIViewController {
        return self
    }
    
    /**
     height for picker view
     - Returns: picker view height.
     */
    func heightForPickerView() -> CGFloat {
        return 200.0
    }
    
    /**
     Cell For
     - Parameter item: JNMentionEntityPickable Item.
     - Parameter tableView: The data list UITableView.
     - Returns: UITableViewCell.
     */
    func jnMentionTextView(cellFor item: JNMentionPickable, tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.getReuseIdentifier()) as? CustomTableViewCell, let user = item as? User {
            cell.setup(user: user)
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    /**
     Height for cell
     - Parameter item: JNMentionEntityPickable item.
     - Parameter tableView: The data list UITableView.
     - Returns: cell height.
     */
    func jnMentionTextView(heightfor item: JNMentionPickable, tableView: UITableView) -> CGFloat {
        return CustomTableViewCell.getCellHeight()
    }
}
