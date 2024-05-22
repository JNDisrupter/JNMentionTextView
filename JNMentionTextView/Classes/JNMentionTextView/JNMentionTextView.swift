//
//  JNMentionTextView.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// Component Values
struct ComponentValues {
    
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
public class JNMentionTextView: UITextView {
    
    /// JNMentionAttributeName
    static let JNMentionAttributeName: NSAttributedString.Key = (NSString("JNMENTIONITEM")) as NSAttributedString.Key

    /// Picker View Controller
    var pickerViewController: JNMentionPickerViewController?

    /// Options
    var options: JNMentionPickerViewOptions!
    
    /// Search String
    var searchString: String!
    
    /// Selected Symbol
    var selectedSymbol: String!
    
    /// Selected Symbol Location
    var selectedSymbolLocation: Int!
    
    /// Selected Symbol Attributes
    var selectedSymbolAttributes: [NSAttributedString.Key : Any]!
    
    /// Normal Attributes
    public var normalAttributes: [NSAttributedString.Key: Any] = [:]
    
    /// Mention Replacements
    public var mentionReplacements: [String: [NSAttributedString.Key : Any]] = [:]
    
    /// Mention Delegate
    public weak var mentionDelegate: JNMentionTextViewDelegate?
    
    /// Placeholder label
    private var placeholderLabel: UILabel?
    
    /// Place holder string
    public var placeHolder: String? {
        
        didSet {
            
            // Add placeholder label subview
            self.addPlaceholderLabelSubview()
        }
    }
    
    /// Place holder Attributes
    public var placeHolderAttributes: [NSAttributedString.Key : Any] = [:] {
        didSet {
            
            // Update placeholder text attributes
            self.updatePlaceholderTextAttributes()
        }
    }
    
    /// Bounds
    override open var bounds: CGRect {
        didSet {
            
            // Resize placeholder
            self.resizePlaceholder()
        }
    }
    
    /// Text
    override open var text: String! {
        didSet {
            self.updatePlaceholderLabelVisibility()
        }
    }
    
    /// Attributed text
    override open var attributedText: NSAttributedString! {
        didSet {
            self.updatePlaceholderLabelVisibility()
        }
    }
    
    /// Font
    public override var font: UIFont? {
        didSet {
            
            // Resize placeholder
            self.resizePlaceholder()
            
            // Update placeholder label font
            self.placeholderLabel?.font = self.placeholderFont
        }
    }
    
    /// Placeholder font
    public var placeholderFont: UIFont {
        get {
            (self.placeHolderAttributes[NSAttributedString.Key.font] as? UIFont) ?? self.font ?? UIFont.systemFont(ofSize: 10.0)
        }
    }
    
    // MARK: - Initializers

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
     Resign First Responder
     - Parameter completion: Completion block.
     */
    public func resignFirstResponder(completion: (() -> ())? = nil){
        
        // end mention process
        self.endMentionProcess(animated: false) {
            self.resignFirstResponder()
            completion?()
        }
    }
    
    /**
     Init View
     */
    private func initView(){
        
        self.selectedSymbol = ""
        self.selectedSymbolLocation = 0
        self.selectedSymbolAttributes = [:]
        self.searchString = ""
        self.pickerViewController = JNMentionPickerViewController()
        self.delegate = self
    }
    
    /**
     Setup
     - Parameter options: JNMentionOptions Object.
     */
    public func setup(options: JNMentionPickerViewOptions) {
        
        // set options
        self.options = options
    }
    
    /**
     Update placeholder visibility
     */
    public func updatePlaceholderLabelVisibility() {
        guard self.placeholderLabel != nil else { return }
        
        // Is placeholder hidden
        var isPlaceholderLabelHidden = true
        
        // Check if there's a placeholder
        // AND value text is empty
        if let placeholder = self.placeHolder,
           !placeholder.isEmpty,
           self.text.isEmpty,
           self.attributedText.string.isEmpty {
            
            isPlaceholderLabelHidden = false
        }
        
        // Update placeholder label visibility
        self.placeholderLabel?.isHidden = isPlaceholderLabelHidden
    }
    
    /**
     Resize placeholder
     */
    private func resizePlaceholder() {
        guard let placeholderLabel = self.placeholderLabel else { return }
        
        // Set placeholder label frame
        placeholderLabel.frame = self.getPlaceholderLabelFrame()
    }
    
    /**
     Add placeholder label subview
     */
    private func addPlaceholderLabelSubview() {
        guard let placeHolder = self.placeHolder, !placeHolder.isEmpty else { return }
        
        // Build placeholder text attributes
        let placeholderTextAttributes = self.getPlaceholderTextAttributes()
        
        // Init placeholder label with frame
        self.placeholderLabel = UILabel(frame: self.getPlaceholderLabelFrame())
        
        // Set placeholder label attributed text
        self.placeholderLabel!.attributedText = NSAttributedString(string: placeHolder, attributes: placeholderTextAttributes)
        
        // Add subview
        self.addSubview(self.placeholderLabel!)
        
        // Update placeholder label visibility
        self.updatePlaceholderLabelVisibility()
    }
    
    /**
     Get placeholder label frame
     */
    private func getPlaceholderLabelFrame() -> CGRect {
        
        return CGRect(x: max(self.textContainerInset.left, self.contentInset.left) + self.textContainer.lineFragmentPadding, y: self.textContainerInset.top, width: self.frame.width, height: self.placeholderFont.lineHeight)
    }

    /**
     Update placeholder text attributes
     */
    private func updatePlaceholderTextAttributes() {
        guard let placeholderLabel = self.placeholderLabel, let placeholderString = self.placeHolder else { return }
        
        // Build placeholder text attributes
        let placeholderTextAttributes = self.getPlaceholderTextAttributes()
        
        // Set placeholder label attributed text
        placeholderLabel.attributedText = NSAttributedString(string: placeholderString, attributes: placeholderTextAttributes)
    }
    
    /**
     Get placeholder text attributes
     */
    private func getPlaceholderTextAttributes() -> [NSAttributedString.Key: Any] {
        
        // Placeholder text attributes
        var placeholderTextAttributes: [NSAttributedString.Key: Any] = [:]
        
        // Set foreground color
        placeholderTextAttributes[NSAttributedString.Key.foregroundColor] = self.placeHolderAttributes[NSAttributedString.Key.foregroundColor] ?? UIColor.lightGray
        
        // Set font
        placeholderTextAttributes[NSAttributedString.Key.font] = self.placeholderFont
        
        // Paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = self.textAlignment
        
        // Set paragraph style
        placeholderTextAttributes[NSAttributedString.Key.paragraphStyle] =  paragraphStyle
        
        return placeholderTextAttributes
    }
    
    /**
     Register Table View Cells
     - Parameter nib: UINib.
     - Parameter identifier: string identifier.
     */
    public func registerTableViewCell(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.pickerViewController?.tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    /**
     Get Mentioned Items
     - Parameter attributedString: NSAttributedString.
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
     Is In Mention Process
     - Returns Bool: Bool value to indicate if the mention is in filter process.
     */
    func isInMentionProcess() -> Bool {
        return ((self.pickerViewController?.viewIfLoaded) != nil) && self.pickerViewController?.view.window != nil
    }
    
    /**
     Move cursor to
     - Parameter location: Location.
     - Parameter completion: completion closure block
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
     Retrieve Data
     - Returns: Pickable data array.
     */
    func pickerViewRetrieveData() {
        
        // Show Loading Indicator View
        self.pickerViewController?.showLoadingIndicatorView()
        
        // Data
        self.mentionDelegate?.jnMentionTextView(retrieveDataFor: self.selectedSymbol, using: self.searchString, compliation: { [weak self] (results) in
            
            // Get strong self refrence
            guard let strongSelf = self else { return }
            
            // Set Data
            strongSelf.pickerViewController?.dataList = results

            if results.isEmpty {
                strongSelf.endMentionProcess()
            }
            
            // Reload Data
            strongSelf.pickerViewController?.reloadData()
        })
    }
}
