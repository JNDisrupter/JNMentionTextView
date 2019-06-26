//
//  JNMentionPickerViewControllerDelegate.swift
//  JNMentionTextView
//
//  Created by JNDisrupter 💡 on 6/26/19.
//

import Foundation

// JNMention Picker View Delegate
protocol JNMentionPickerViewControllerDelegate: NSObjectProtocol {
    
    /**
     Retrieve Data
     - Returns: Pickable data array.
     */
    func pickerViewRetrieveData() -> [JNMentionPickable]
    
    /**
     Get Cell
     - Parameter item: Pickable item.
     - Returns: UITableViewCell.
     */
    func jnMentionPickerViewController(cellFor item: JNMentionPickable) -> UITableViewCell
    
    /**
     Height for cell
     - Parameter item: Pickable item.
     - Returns: UITableViewCell.
     */
    func jnMentionPickerViewController(cellHeightFor item: JNMentionPickable) -> CGFloat
    
    /**
     Did Select Item
     - Parameter indexPath: IndexPath.
     */
    func jnMentionPickerViewController(didSelectItemAt indexPath: IndexPath)
}
