//
//  ViewController.swift
//  JNMentionTextView
//
//  Created by ihmouda on 05/20/2019.
//  Copyright (c) 2019 ihmouda. All rights reserved.
//

import UIKit
import JNMentionTextView

/// User
struct User {
    
    var id: Int
    var name: String
}

/// JNMentionEntityPickable
extension User: JNMentionEntityPickable {
    
    /**
     Get Pickable title
     - Returns: The pickable title text.
     */
    func getPickableTitle() -> String {
        return self.name
    }
    
    /**
     Get Pickable Identifier
     - Returns: The pickable Identifier string.
     */
    func getPickableIdentifier() -> String {
        return self.id.description
    }
}

/// ViewController
class ViewController: UIViewController {

    /// Text View
    @IBOutlet weak var textView: JNMentionTextView!
    
    /// Data
    var data: [String: [JNMentionEntityPickable]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // customize text view apperance
        self.textView.font = UIFont.systemFont(ofSize: 17.0)
        
        // set text view mention delegate
        self.textView.mentionDelegate = self
        
        // init options
        let options = JNMentionOptions(borderColor: .gray, borderWitdth: 1.0, backgroundColor: .clear, listViewBackgroundColor: .white, pickerViewHeight: 100.0, viewMode: JNMentionViewMode.bottom(JNMentionViewMode.accessoryView.triangle(length: 15.0)),
                                       mentionReplacements: ["@": [NSAttributedString.Key.foregroundColor: UIColor.blue,
                                                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]],
                                       normalAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])

        
        // build data
        let firstUser  = User(id: 1, name: "Tom Hanks")
        let secondUser = User(id: 2, name: "Leonardo DiCaprio")
        let thirdUser  = User(id: 3, name: "Morgan Freeman")
        let fourthUser = User(id: 4, name: "Samuel L. Jackson")
        let fifthUser  = User(id: 5, name: "Tom Cruise")

        // set data
        self.data = ["@": [firstUser, secondUser, thirdUser, fourthUser, fifthUser]]
        
        // etup text view
        self.textView.setup(options: options)

    }
    
    /**
     Get Mentioned Items
     */
    @IBAction func getMentionedItems(_ sender: Any) {
        
        let items = self.textView.getMentionedItems(for: "@")
        print(items)
        
    }
}

/// JNMentionTextViewDelegate
extension ViewController: JNMentionTextViewDelegate {
 
    /**
     Get Mention Item For
     - Parameter symbol: replacement string.
     - Parameter id: JNMentionEntityPickable ID.
     - Returns: JNMentionEntityPickable object for the search criteria.
     */
    func getMentionItemFor(symbol: String, id: String) -> JNMentionEntityPickable? {

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
    func retrieveDataFor(_ symbole: String, using searchTerm: String) -> [JNMentionEntityPickable] {
        
        var data = self.data[symbole] ?? []
        if !searchTerm.isEmpty {
            data = data.filter({ $0.getPickableTitle().contains(searchTerm)})
        }

        return data
    }
    
    /**
     Cell For
     - Parameter item: JNMentionEntityPickable Item.
     - Parameter tableView: The data list UITableView.
     - Returns: UITableViewCell.
     */
    func cell(for item: JNMentionEntityPickable, tableView: UITableView) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = item.getPickableTitle()
        return cell
    }
    
    /**
     Height for cell
     - Parameter item: JNMentionEntityPickable item.
     - Parameter tableView: The data list UITableView.
     - Returns: cell height.
     */
    func heightForCell(for item: JNMentionEntityPickable, tableView: UITableView) -> CGFloat {
        return 50.0
    }
    
}
