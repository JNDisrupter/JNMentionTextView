//
//  JNMentionTextView.swift
//  JNMentionTextView_Example
//
//  Created by mihmouda on 6/2/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

/// Component Values
private struct ComponentValues {
    
    // Default Cell Height
    static let defaultCellHeight: CGFloat = 50.0
}

/// JNMentionEntity
public struct JNMentionEntity {
    
    /// Ranage
    var range: NSRange
    
    /// Symbol
    var symbol: String
    
    /// Pickable Item
    var item: JNMentionEntityPickable

    /**
     Initializer
     - Parameter item: JNMentionEntityPickable Item
     - Parameter symbol: Symbol special character
     */
    init(item: JNMentionEntityPickable, symbol: String) {
        
        self.item = item
        self.symbol = symbol
        self.range = NSRange(location: 0, length: 0)
    }
}

/// JNMentionTextView
open class JNMentionTextView: UITextView {
    
    /// JNMentionAttributeName
    static let JNMentionAttributeName: NSAttributedString.Key = (NSString("JNMENTIONITEM")) as NSAttributedString.Key

    /// Selected Symbol
    var selectedSymbol: String!
    
    /// Selected Symbol Location
    var selectedSymbolLocation: Int!
    
    /// Selected Symbol Attributes
    var selectedSymbolAttributes: [NSAttributedString.Key : Any]!
    
    /// Search String
    var searchString: String!
    
    /// Options
    var options: JNMentionOptions!
    
    /// Picker View
    var pickerView: JNMentionPickerView!
    
    /// Mention Delegate
    open weak var mentionDelegate: JNMentionTextViewDelegate?
    
    /// Normal Attributes
    var normalAttributes: [NSAttributedString.Key: Any] = [:]
    
    // MARK:- Initializers

    /**
     Initializer
     */
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.initView()
    }
    
    /**
     Initializer
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initView()
    }
    
    /**
     Init View
     */
    private func initView(){
        
        self.selectedSymbol = ""
        self.selectedSymbolLocation = 0
        self.selectedSymbolAttributes = [:]
        self.searchString = ""
        self.delegate = self
    }
    
    /**
     Setup
     - Parameter options: JNMentionOptions Object.
     */
    open func setup(options: JNMentionOptions) {
        
        // set options
        self.options = options
        
        // init picker view
        self.initPickerView()
        
        // set picker view delegate
        self.pickerView.delegate = self
    }

    /**
     Register Table View Cells
     - Parameter cells: list of Table View Cells.
     */
    open func registerTableViewCell(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.pickerView.tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    /**
     Get Mentioned Items
     - Parameter symbol: Symbol string value.
     - Returns [JNMentionEntity]: list of mentioned (JNMentionEntity)
     */
    open func getMentionedItems(for symbol: String) -> [JNMentionEntity] {
        
        var mentionedItems: [JNMentionEntity] = []
        
        self.attributedText.enumerateAttributes(in: NSRange(0..<self.textStorage.length), options: [], using:{ attrs, range, stop in
            
            if let item = (attrs[JNMentionTextView.JNMentionAttributeName] as AnyObject) as? JNMentionEntity, item.symbol == symbol {
                
                var mentionedItem = item
                mentionedItem.range = range
                mentionedItems.append(mentionedItem)
            }
        })
        
        return mentionedItems
    }
    
    /**
     Is In Filter Process
     - Returns Bool: Bool value to indicate if the mention is in filter process.
     */
    func isInFilterProcess() -> Bool {
        return !self.pickerView.isHidden
    }
    
    /**
     Move cursor to
     - Parameter location: Location.
     */
    func moveCursor(to location: Int) {
        
        // get cursor position
        if let newPosition = self.position(from: self.beginningOfDocument, offset: location) {
            DispatchQueue.main.async {
                self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    /**
     post filtering process
     - Parameter selectedRange: NSRange.
     */
    func postFilteringProcess(in selectedRange: NSRange) {
        self.pickerView.tableView.reloadData()
        self.uppdatePickerViewFrame(selectedRange: selectedRange)
    }
}

/// JNMention Text View Delegate
public protocol JNMentionTextViewDelegate: UITextViewDelegate {
    
    /**
     Get Mention Item For
     - Parameter symbol: replacement string.
     - Parameter id: JNMentionEntityPickable ID.
     - Returns: JNMentionEntityPickable objects for the search criteria.
     */
    func getMentionItemFor(symbol: String, id: String) -> JNMentionEntityPickable?
    
    /**
     Retrieve Data For
     - Parameter symbol: replacement string.
     - Parameter searchString: search string.
     - Returns: list of JNMentionEntityPickable objects for the search criteria.
     */
    func retrieveDataFor(_ symbol: String, using searchString: String) -> [JNMentionEntityPickable]
    
    /**
     Cell For
     - Parameter item: JNMentionEntityPickable Item.
     - Parameter tableView: The data list UITableView.
     - Returns: UITableViewCell.
     */
    func cell(for item: JNMentionEntityPickable, tableView: UITableView) -> UITableViewCell
    
    /**
     Height for cell
     - Parameter item: JNMentionEntityPickable item.
     - Parameter tableView: The data list UITableView.
     - Returns: cell height.
     */
    func heightForCell(for item: JNMentionEntityPickable, tableView: UITableView) -> CGFloat
    
    /**
     Super View For Picker View
     - Returns: the super view for the picker view.
     */
    func superViewForPickerView() -> UIView
    
    /**
     height for picker view
     - Returns: picker view height.
     */
    func heightForPickerView() -> CGFloat
}


/// JNMentionTextViewDelegate
public extension JNMentionTextViewDelegate {

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
        return ComponentValues.defaultCellHeight
    }
}
