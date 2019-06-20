//
//  JNMentionTextView.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
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
    public var range: NSRange
    
    /// Symbol
    public var symbol: String
    
    /// Pickable Item
     public var item: JNMentionPickable

    /**
     Initializer
     - Parameter item: JNMentionEntityPickable Item
     - Parameter symbol: Symbol special character
     */
    init(item: JNMentionPickable, symbol: String) {
        
        self.item = item
        self.symbol = symbol
        self.range = NSRange(location: 0, length: 0)
    }
}

/// JNMentionTextView
open class JNMentionTextView: UITextView {
    
    /// JNMentionAttributeName
    static let JNMentionAttributeName: NSAttributedString.Key = (NSString("JNMENTIONITEM")) as NSAttributedString.Key

    /// Picker View
    var pickerView: JNMentionPickerView!
    
    /// Options
    var options: JNMentionPickerViewOptions!
    
    /// Mention Replacements
    public var mentionReplacements: [String: [NSAttributedString.Key : Any]] = [:]
    
    /// Normal Attributes
    var normalAttributes: [NSAttributedString.Key: Any] = [:]
    
    /// previous offset
    var previousOffset: CGPoint = CGPoint.zero
    
    /// Search String
    var searchString: String!
    
    /// Selected Symbol
    var selectedSymbol: String!
    
    /// Selected Symbol Location
    var selectedSymbolLocation: Int!
    
    /// Selected Symbol Attributes
    var selectedSymbolAttributes: [NSAttributedString.Key : Any]!
    
    /// Mention Delegate
    public weak var mentionDelegate: JNMentionTextViewDelegate?
    
    // MARK:- Initializers

    /**
     Initializer
     */
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
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
    public func setup(options: JNMentionPickerViewOptions) {
        
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
    public func registerTableViewCell(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.pickerView.tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    /**
     Get Mentioned Items
     - Parameter symbol: Symbol string value.
     - Returns [JNMentionEntity]: list of mentioned (JNMentionEntity)
     */
    public class func getMentionedItems(from attributedString: NSAttributedString, symbol: String = "") -> [JNMentionEntity] {
        
        var mentionedItems: [JNMentionEntity] = []
        
        attributedString.enumerateAttributes(in: NSRange(0..<attributedString.length), options: [], using:{ attrs, range, stop in
            
            if let item = (attrs[JNMentionTextView.JNMentionAttributeName] as AnyObject) as? JNMentionEntity {
                
                if !symbol.isEmpty, symbol != item.symbol {
                    return
                }
                
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
    func moveCursor(to location: Int, completion:(() -> ())? = nil) {
        
        // get cursor position
        if let newPosition = self.position(from: self.beginningOfDocument, offset: location) {
            DispatchQueue.main.async {
                self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
                
                completion?()
            }
        }
    }
    
    /**
     post filtering process
     - Parameter selectedRange: NSRange.
     */
    func postFilteringProcess(in selectedRange: NSRange, completion:(() -> ())? = nil) {
        self.pickerView.tableView.reloadData()
        self.setPickerViewFrame(completion: {
                completion?()
        })
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
    func jnMentionTextView(getMentionItemFor symbol: String, id: String) -> JNMentionPickable?
    
    /**
     Retrieve Data For
     - Parameter symbol: replacement string.
     - Parameter searchString: search string.
     - Returns: list of JNMentionEntityPickable objects for the search criteria.
     */
    func jnMentionTextView(retrieveDataFor symbol: String, using searchString: String) -> [JNMentionPickable]
    
    /**
     Cell For
     - Parameter item: JNMentionEntityPickable Item.
     - Parameter tableView: The data list UITableView.
     - Returns: UITableViewCell.
     */
    func jnMentionTextView(cellFor item: JNMentionPickable, tableView: UITableView) -> UITableViewCell
    
    /**
     Height for cell
     - Parameter item: JNMentionEntityPickable item.
     - Parameter tableView: The data list UITableView.
     - Returns: cell height.
     */
    func jnMentionTextView(heightfor item: JNMentionPickable, tableView: UITableView) -> CGFloat
    
    /**
     Container View For Picker View
     - Returns: the super view for the picker view.
     */
    func containerViewForPickerView() -> UIView
    
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
    func jnMentionTextView(cellFor item: JNMentionPickable, tableView: UITableView) -> UITableViewCell {
        
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
     func jnMentionTextView(heightfor item: JNMentionPickable, tableView: UITableView) -> CGFloat {
        return ComponentValues.defaultCellHeight
    }
}
