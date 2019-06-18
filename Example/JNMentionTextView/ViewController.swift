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
extension User: JNMentionPickable {
    
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
    var data: [String: [JNMentionPickable]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // customize text view apperance
        self.textView.font = UIFont.systemFont(ofSize: 17.0)
        self.textView.mentionReplacements = ["@": [NSAttributedString.Key.foregroundColor: UIColor.blue,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]]
        
        // init options
        let options = JNMentionPickerViewOptions(borderColor: .gray, borderWitdth: 1.0, viewPositionMode: JNMentionPickerViePositionwMode.top(JNMentionPickerViePositionwMode.accessoryView.triangle(sideLength: 15.0)))

        
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
        
        // set mention delegate
        self.textView.mentionDelegate = self
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
    func getMentionItemFor(symbol: String, id: String) -> JNMentionPickable? {

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
    func retrieveDataFor(_ symbole: String, using searchTerm: String) -> [JNMentionPickable] {
        
        var data = self.data[symbole] ?? []
        if !searchTerm.isEmpty {
            data = data.filter({ $0.getPickableTitle().lowercased().contains(searchTerm.lowercased())})
        }

        return data
    }
    
    /**
     Super View For Picker View
     - Returns: the super view for the picker view.
     */
    func superViewForPickerView() -> UIView {
        return self.view
    }
    
    /**
     height for picker view
     - Returns: picker view height.
     */
    func heightForPickerView() -> CGFloat {
        return 100.0
    }
}
