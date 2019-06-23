//
//  JNMentionPickerViewController.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/21/19.
//

import UIKit


/// JN Mention Picker View Controller
class JNMentionPickerViewController: UIViewController {

    /// Table View
    var tableView: UITableView!
    
    /// Options
    var options: JNMentionPickerViewOptions!
    
    /// Delegate
    weak var delegate: JNMentionPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTableView(with: self.options)
    }
    


    /**
     Init Table View
     - Parameter options: JNMentionPickerViewOptions
     */
    private func initTableView(with options: JNMentionPickerViewOptions) {
        
        // init table view
        self.tableView = UITableView(frame: CGRect.zero)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //self.view.layer.borderColor = options.borderColor.cgColor
       // self.view.layer.borderWidth = options.borderWitdth
        self.view.backgroundColor = UIColor.clear//options.backgroundColor
        self.tableView.backgroundColor = UIColor.clear
        self.view.addSubview(self.tableView)
        
        // top and bottom constants
        var topAnchorConstant: CGFloat = 0.0
        var bottomAnchorConstant: CGFloat = 0.0
        
        // update the constants according to view position mode
        switch options.viewPositionMode {
        case .top(let accessoryView), .enclosedTop(let accessoryView):
            switch accessoryView {
            case .triangle(let length):
                topAnchorConstant = 0.0
                bottomAnchorConstant = -(length * CGFloat (3.0.squareRoot()) / 2.0)
            case .none:
                break
            }
        case .bottom(let accessoryView), .enclosedBottom(let accessoryView):
            switch accessoryView {
            case .triangle(let length):
                topAnchorConstant = (length * CGFloat (3.0.squareRoot()) / 2.0)
                bottomAnchorConstant = 0.0
            case .none:
                break
            }
        }
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topAnchorConstant),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: bottomAnchorConstant)
            ])
    }

}


// UITableViewDelegate & UITableViewDataSource
extension JNMentionPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    /**
     Number Of Sections
     */
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     Number Of Rows In Section
     */
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate?.pickerViewRetrieveData().count ?? 0
    }
    
    /**
     Cell For Row At
     */
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // data
        let data = self.delegate?.pickerViewRetrieveData() ?? []
        
        // get cell for pickable item
        if data.count > indexPath.row {
            return self.delegate?.cell(for: data[indexPath.row]) ?? UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    /**
     Height for row at
     */
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // data
        let data = self.delegate?.pickerViewRetrieveData() ?? []
        
        // get cell for pickable item
        if data.count > indexPath.row {
            return self.delegate?.heightForCell(for: data[indexPath.row]) ?? UITableView.automaticDimension
        }
        
        return UITableView.automaticDimension
    }
    
    /**
     Did Select Row At
     */
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // did select item
        self.delegate?.didSelectItem(at: indexPath)
    }
}

// JNMention Picker View Delegate
public protocol JNMentionPickerViewControllerDelegate: NSObjectProtocol {
    
    /**
     Retrieve Data
     - Returns: Pickable data array.
     */
    func pickerViewRetrieveData() -> [JNMentionPickable]
    
    /**
     Cell
     - Parameter item: Pickable item.
     - Returns: UITableViewCell.
     */
    func cell(for item: JNMentionPickable) -> UITableViewCell
    
    /**
     Height for cell
     - Parameter item: Pickable item.
     - Returns: UITableViewCell.
     */
    func heightForCell(for item: JNMentionPickable) -> CGFloat
    
    /**
     Did Select Item
     - Parameter indexPath: IndexPath.
     */
    func didSelectItem(at indexPath: IndexPath)
}


class MyPopoverBackgroundView : UIPopoverBackgroundView {

    var arrOff : CGFloat
    var arrDir : UIPopoverArrowDirection
    
    override init(frame:CGRect) {
        self.arrOff = 0
        self.arrDir = .up
        super.init(frame:frame)
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.red.cgColor
        //self.backgroundColor = UIColor.purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20)
    }
    
    override class func arrowBase() -> CGFloat { return 10 }
    override class func arrowHeight() -> CGFloat { return 20 }
    
    override var arrowDirection : UIPopoverArrowDirection {
        get { return self.arrDir }
        set { self.arrDir = newValue }
    }
    override var arrowOffset : CGFloat {
        get { return self.arrOff }
        set { self.arrOff = newValue }
    }
    
    override class var wantsDefaultContentAppearance : Bool {
        return true // try false to see if you can find a difference...
    }
    
}
