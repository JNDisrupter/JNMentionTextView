//
//  JNMentionPickerView+TableDelegate.swift
//  JNMentionTextView_Example
//
//  Created by mihmouda on 6/2/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

// UITableViewDelegate & UITableViewDataSource
extension JNMentionPickerView: UITableViewDelegate, UITableViewDataSource {
    
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
        
        // set is hidden
        self.isHidden = true
    }
}
