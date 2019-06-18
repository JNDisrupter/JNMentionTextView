//
//  JNMentionPickerView.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// JNMention Picker View
public class JNMentionPickerView: UIView {
    
    /// Path
    var bezierPath: UIBezierPath!
    
    /// Shape
    var shapeLayer: CAShapeLayer!
    
    /// Table View
    var tableView: UITableView!
    
    /// Delegate
    weak var delegate: JNMentionPickerViewDelegate?
    
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
        self.backgroundColor = UIColor.red
        
        // set is hidden
        self.isHidden = true
    }
    
    /**
     Setup
     - Parameter options: JNMention Picker View Options
     */
    func setup(options: JNMentionPickerViewOptions) {
        
        // init table view
        self.initTableView(with: options)
    }
    
    /**
     Draw Triangle
     - Parameter options: JNMention Picker View Options
     - Parameter cursorOffset: Cursor offset value.
     */
    func drawTriangle(options: JNMentionPickerViewOptions, cursorOffset: CGFloat) {
        
        // remove all previous drawing
        self.bezierPath.removeAllPoints()
        self.shapeLayer.removeFromSuperlayer()
        
        // skip if the parent view is hidden
        guard !self.tableView.visibleCells.isEmpty else { return }

        switch options.viewPositionMode {
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
                
            case .none:
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
                
            case .none:
                break
            }
        }
    }
    
    /**
     Draw Triangle Path
     */
    private func drawTrianglePath(options: JNMentionPickerViewOptions){
        
        // fill the path
        self.bezierPath.close()
        
        // customize the shape apprance
        shapeLayer.frame = self.bounds
        shapeLayer.path = self.bezierPath.cgPath
        shapeLayer.fillColor = options.backgroundColor.cgColor
        self.layer.addSublayer(shapeLayer)
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
        
        self.tableView.layer.borderColor = options.borderColor.cgColor
        self.tableView.layer.borderWidth = options.borderWitdth
        self.tableView.backgroundColor = options.backgroundColor
        
        self.addSubview(self.tableView)
        
        // top and bottom constants
        var topAnchorConstant: CGFloat = 0.0
        var bottomAnchorConstant: CGFloat = 0.0
        
        // update the constants according to view position mode
        switch options.viewPositionMode {
        case .top(let accessoryView):
            switch accessoryView {
            case .triangle(let length):
                topAnchorConstant = 0.0
                bottomAnchorConstant = -(length * CGFloat (3.0.squareRoot()) / 2.0)
            case .none:
                break
            }
        case .bottom(let accessoryView):
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
