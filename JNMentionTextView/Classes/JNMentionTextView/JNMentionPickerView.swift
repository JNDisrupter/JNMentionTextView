//
//  JNMentionPickerView.swift
//  JNMentionTextView_Example
//
//  Created by mihmouda on 6/2/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

/// JNMention Picker View
open class JNMentionPickerView: UIView {
    
    /// Path
    var bezierPath: UIBezierPath!
    
    /// Shape
    var shapeLayer: CAShapeLayer!
    
    /// Table View
    var tableView: UITableView!
    
    /// Delegate
    weak open var delegate: JNMentionPickerViewDelegate?
    
    /**
     Initializer
     */
    convenience public init() {
        self.init(frame: CGRect.zero)
        
        // Init view
        self.initView()
    }
    
    /**
     Initializer
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Init view
        self.initView()
    }
    
    /**
     Initializer
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Init view
        self.initView()
    }
    
    /**
     Init view
     */
    private func initView() {
        
        // init shape and draw paths
        self.bezierPath = UIBezierPath()
        self.shapeLayer = CAShapeLayer()
        
        // set is hidden
        self.isHidden = true
    }
    
    /**
     Setup
     - Parameter options: JNMentionOptions
     */
    func setup(options: JNMentionOptions) {
        
        // set background color
        self.backgroundColor = options.backgroundColor
        
        // init table view
        self.initTableView(with: options)
    }
    
    /**
     Draw Triangle
     - Parameter mode: JNMention View Mode.
     - Parameter cursorOffset: Cursor offset value.
     */
    func drawTriangle(options: JNMentionOptions, cursorOffset: CGFloat) {
        
        // remove all previous drawing
        self.bezierPath.removeAllPoints()
        self.shapeLayer.removeFromSuperlayer()
        
        // skip if the parent view is hidden
        guard !self.tableView.visibleCells.isEmpty else { return }

        switch options.viewMode {
        case .bottom(let accessoryView):
            switch accessoryView {
            case .triangle(let length):
                
                // calculate triangle height
                let height = length * CGFloat (3.0.squareRoot()) / 2.0
                
                self.bezierPath.move(to: CGPoint(x: cursorOffset, y: 0))
                self.bezierPath.addLine(to: CGPoint(x: cursorOffset - length / 2, y: height))
                self.bezierPath.addLine(to: CGPoint(x: cursorOffset + length / 2, y: height))
                
                // draw triangle path
                self.drawTrianglePath(options: options)
                
            case .plain:
                break
                
            }
            
        case .top(let accessoryView):
            switch accessoryView {
            case .triangle(let length):
                
                // calculate triangle height
                let height = length * CGFloat (3.0.squareRoot()) / 2.0
                
                // make the triangle position stick to the textview boundaries
                var cursorOffset = cursorOffset
                
                // position less than the length / 2
                if cursorOffset < length / 2 {
                    cursorOffset = length / 2
                }
                
                // position greater than the witdth
                if cursorOffset + length / 2 > self.frame.width {
                    cursorOffset = self.frame.width - length / 2
                }
                
                self.bezierPath.move(to: CGPoint(x: cursorOffset > 0 ? cursorOffset + length / 2 : length , y: self.frame.height - height))
                self.bezierPath.addLine(to: CGPoint(x: cursorOffset > 0 ? cursorOffset - length / 2 : 0 , y: self.frame.size.height - height))
                self.bezierPath.addLine(to: CGPoint(x: cursorOffset > 0 ? cursorOffset : length / 2 , y: self.frame.size.height))
                
                // draw triangle path
                self.drawTrianglePath(options: options)
                
            case .plain:
                break
            }
        }
    }
    
    /**
     Draw Triangle Path
     */
    private func drawTrianglePath(options: JNMentionOptions){
        
        // fill the path
        self.bezierPath.fill()
        
        // customize the shape apprance
        shapeLayer.frame = self.bounds
        shapeLayer.path = self.bezierPath.cgPath
        shapeLayer.fillColor = options.listViewBackgroundColor.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }
    
    /**
     Init Table View
     - Parameter options: JNMentionOptions
     */
    private func initTableView(with options: JNMentionOptions) {

        // init table view
        self.tableView = UITableView(frame: self.bounds)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.layer.borderColor = options.borderColor.cgColor
        self.tableView.layer.borderWidth = options.borderWitdth
        self.tableView.backgroundColor = options.listViewBackgroundColor
        
        self.addSubview(self.tableView)
        
        // top and bottom constants
        var topAnchorConstant: CGFloat = 0.0
        var bottomAnchorConstant: CGFloat = 0.0
        
        // update the constants according to view mode
        
        switch options.viewMode {
        case .top(let accessoryView):
            switch accessoryView {
            case .triangle(let length):
                topAnchorConstant = 0.0
                bottomAnchorConstant = -(length * CGFloat (3.0.squareRoot()) / 2.0)
            case .plain:
                break
            }
        case .bottom(let accessoryView):
            switch accessoryView {
            case .triangle(let length):
                topAnchorConstant = (length * CGFloat (3.0.squareRoot()) / 2.0)
                bottomAnchorConstant = 0.0
            case .plain:
                break
            }
        }
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: topAnchorConstant),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomAnchorConstant)
            ])
    }
}

// JNMention Picker View Delegate
public protocol JNMentionPickerViewDelegate: NSObjectProtocol {
    
    /**
     Retrieve Data
     - Returns: Pickable data array.
     */
    func pickerViewRetrieveData() -> [JNMentionEntityPickable]
    
    /**
     Cell
     - Parameter item: Pickable item.
     - Returns: UITableViewCell.
     */
    func cell(for item: JNMentionEntityPickable) -> UITableViewCell
    
    /**
     Height for cell
     - Parameter item: Pickable item.
     - Returns: UITableViewCell.
     */
    func heightForCell(for item: JNMentionEntityPickable) -> CGFloat
    
    /**
     Did Select Item
     - Parameter indexPath: IndexPath.
     */
    func didSelectItem(at indexPath: IndexPath)
}
