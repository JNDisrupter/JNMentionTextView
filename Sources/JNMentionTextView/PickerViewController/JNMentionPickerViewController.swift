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
    
    /// Loading Indicator View
    var loadingIndicatorView: UIActivityIndicatorView!
    
    /// Options
    var options: JNMentionPickerViewOptions = JNMentionPickerViewOptions(viewPositionMode: JNMentionPickerViewPositionwMode.automatic)
    
    /// Table View
    var dataList: [JNMentionPickable] = []
    
    /// Delegate
    weak var delegate: JNMentionPickerViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initSubViews(with: self.options)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     View Did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSubViews(with: self.options)
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
     Init Sub Views
     - Parameter options: JNMentionPickerViewOptions
     */
    private func initSubViews(with options: JNMentionPickerViewOptions) {
        
        // Init Table View
        self.initTableView(with: self.options)
        
        // Init Loading View
        self.initLoadingIndicatorView()
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
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
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
     Init Loading Indicator View
     */
    private func initLoadingIndicatorView() {
        
        // init table view
        self.loadingIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        self.loadingIndicatorView.frame = CGRect.zero
        self.view.addSubview(self.loadingIndicatorView)
        
        self.loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.loadingIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loadingIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
    }
    
    /**
     Show Loading Indicator View
     */
    func showLoadingIndicatorView() {
        if self.dataList.isEmpty {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.startAnimating()
        }
    }
    
    /**
     Reload Data
     */
    func reloadData() {
        self.loadingIndicatorView.isHidden = true
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
        return self.dataList.count
    }
    
    /**
     Cell For Row At
     */
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get cell for pickable item
        if self.dataList.count > indexPath.row {
            return self.delegate?.jnMentionPickerViewController(cellFor: self.dataList[indexPath.row]) ?? UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    /**
     Height for row at
     */
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // get cell for pickable item
        if self.dataList.count > indexPath.row {
            return self.delegate?.jnMentionPickerViewController(cellHeightFor: self.dataList[indexPath.row]) ?? UITableView.automaticDimension
        }
        
        return UITableView.automaticDimension
    }
    
    /**
     Did Select Row At
     */
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // did select item
        self.delegate?.jnMentionPickerViewController(didSelectItemAt: indexPath)
    }
}
