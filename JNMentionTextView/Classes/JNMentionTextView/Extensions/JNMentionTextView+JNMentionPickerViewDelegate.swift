//
//  JNMentionTextView+JNMentionPickerViewDelegate.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/17/19.
//

import UIKit

/// JNMentionPickerViewDelegate
extension JNMentionTextView: JNMentionPickerViewControllerDelegate {
    
    /**
     Retrieve Data
     - Returns: Pickable data array.
     */
    public func pickerViewRetrieveData() -> [JNMentionPickable] {
        
        // Data
        let data =  self.mentionDelegate?.jnMentionTextView(retrieveDataFor: self.selectedSymbol, using: self.searchString) ?? []
        if data.isEmpty {
            if let pickerView = self.pickerViewController {
                pickerView.dismiss(animated: true, completion: {
                     self.pickerViewController = nil
                    self.endMentionProcess()
                })
            }
           
        }
        return data
    }
    
    /**
     Cell
     - Parameter item: Pickable item.
     - Returns: UITableViewCell.
     */
    public func cell(for item: JNMentionPickable) -> UITableViewCell {
        return self.mentionDelegate?.jnMentionTextView(cellFor: item, tableView: self.pickerView.tableView) ?? UITableViewCell()
    }
    
    /**
     Height for cell
     - Parameter item: Pickable item.
     - Returns: UITableViewCell.
     */
    public func heightForCell(for item: JNMentionPickable) -> CGFloat {
        return self.mentionDelegate?.jnMentionTextView(heightfor: item, tableView: self.pickerView.tableView) ?? 0.0
    }
    
    /**
     Did Select Item
     - Parameter indexPath: IndexPath.
     */
    public func didSelectItem(at indexPath: IndexPath) {
        
        if let data = self.mentionDelegate?.jnMentionTextView(retrieveDataFor: self.selectedSymbol, using: self.searchString) {
            
            // selected item & range
            let selectedItem = data[indexPath.row]
            
            // selected location
            guard let selectedRange = selectedTextRange else { return }
            let location = offset(from: beginningOfDocument, to: selectedRange.start)
            
            // replace characters with pickable item
            self.replaceCharacters(with: selectedItem, in: location)
            
            // Trigger text did change
            self.textViewDidChange(self)
        }
    }
}
