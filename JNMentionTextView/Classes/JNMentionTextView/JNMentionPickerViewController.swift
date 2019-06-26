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
    var options: JNMentionPickerViewOptions = JNMentionPickerViewOptions(viewPositionMode: JNMentionPickerViewPositionwMode.automatic)
    
    /// Delegate
    weak var delegate: JNMentionPickerViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initTableView(with: self.options)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     View Did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTableView(with: self.options)
    }

    /**
     View Will Appear
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload Data
        self.tableView.reloadData()
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
        
        self.view.backgroundColor = options.backgroundColor
        self.tableView.backgroundColor = UIColor.clear
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
       ])
    }
    
    /**
     Reload Data
     */
    func reloadData() {
        self.tableView.reloadData()
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
