# JNMentionTextView

[![CI Status](https://img.shields.io/travis/ihmouda/JNMentionTextView.svg?style=flat)](https://travis-ci.org/ihmouda/JNMentionTextView)
[![Version](https://img.shields.io/cocoapods/v/JNMentionTextView.svg?style=flat)](https://cocoapods.org/pods/JNMentionTextView)
[![License](https://img.shields.io/cocoapods/l/JNMentionTextView.svg?style=flat)](https://cocoapods.org/pods/JNMentionTextView)
[![Platform](https://img.shields.io/cocoapods/p/JNMentionTextView.svg?style=flat)](https://cocoapods.org/pods/JNMentionTextView)

**JNMentionTextView** is a UITextView drop-in replacement supporting special characters such as [ #, @ ], written in Swift. **JNMentionTextView** is a custom easy to use UITextView providing powerful tool and supportting for creating **‘Mention’** annotations in to your iOS app; Annotations which refers to names of individuals or entities and treated as a single unit and can be styled differently from the rest of the text.



## Preview

<img src="https://github.com/JNDisrupter/JNMentionTextView/raw/master/Images/mention-1.gif" width="260"/> <img src="https://github.com/JNDisrupter/JNMentionTextView/raw/master/Images/mention-2.gif" width="260"/> <img src="https://github.com/JNDisrupter/JNMentionTextView/raw/master/Images/mention-3.gif" width="260"/> <img src="https://github.com/JNDisrupter/JNMentionTextView/raw/master/Images/mention-4.gif" width="260"/> <img src="https://github.com/JNDisrupter/JNMentionTextView/raw/master/Images/mention-5.gif" width="260"/> 


## Requirements

- Xcode 9
- iOS 9.0+
- Swift 4.2+


## Installation

JNMentionTextView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```swift
pod 'JNMentionTextView'
```

## Usage:

- Import **JNMentionTextView** module
```swift
import JNMentionTextView
```

- **Initalization:**
    - ***Storyboard:***
    Manually, you can add a UITextView instance to your Xib, set **'JNMentionTextView'** class and connect @IBOutlet reference.

    - ***Programmatically:***
    Init ‘JNMentionTextView’ UITextView instance programatically.

    ```swift
    let textView = JNMentionTextView()
    self.view.addSubview(textView)
    ```

-  **Setup:**
  
      - ***Setup the mention replacements:***
        as dictionary of special characters used in mention process [ #, @ ] with their crossponding style.

      ```swift
      self.textView.mentionReplacements = ["@": [NSAttributedString.Key.foregroundColor: UIColor.blue,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]]
      ```

      - ***Setup the data list:***
        The list of entities that you can select, as instance of class / struct which confirms to the **JNMentionPickable**           protocol by implementing his methods:

          - ****getPickableTitle:**** return the title of entities which you can select.

           ```swift
           getPickableTitle() -> String
           ```

          - ***getPickableIdentifier:*** used to uniquely identify the entities - Entity id -.

           ```swift
           getPickableIdentifier() -> String
           ```

      - ***Setup the data list picker options:***

        ```swift
         self.textView.setup(options: JNMentionOptions()
        ```

        - ****Options Customization:****
            Customize the data list apperance (Picker View):

            - **backgroundColor**: picker view background color.
            - **viewPositionMode**: can support one or more of three view modes:
                - **Up**
                - **Down**
                - **Automatic**
                ```swift
                JNMentionOptions(
                 backgroundColor: UIColor.white,
                 viewPositionMode: JNMentionPickerViewPositionwMode.automatic)
                ```

 ## JNMentionTextViewDelegate
   - Your class must use the **JNMentionTextViewDelegate** Protocol and conform to it by implementing its required methods in        **JNMentionTextViewDelegate**:

   ```swift
   self.textView.mentionDelegate = self
   ```

   - **Retrieve Data For Symbol:** In this method retrieve data of **JNMentionPickable** objects as the data list to be picked according to search text that had been typed in textview also this opeartion will be async and the loading activity indictor will appear in Picker view.

   ```swift
   func jnMentionTextView(retrieveDataFor symbol: String, using searchString: String, compliation: (([JNMentionPickable]) -> ()) {
        var data = self.data[symbol] ?? []
        if !searchString.isEmpty {
            data = data.filter({ $0.getPickableTitle().lowercased().contains(searchString.lowercased())})
        }
        
        return compliation(data)
    }
  ```


   - **Get Mention Item For Symbol:** In this method retrieve  **JNMentionPickable** object to be converted to mention annotation in the **setSmartText** method
   ```swift
    func jnMentionTextView(getMentionItemFor symbol: String, id: String) -> JNMentionPickable? {
        for item in self.data[symbol] ?? [] {
            if item.getPickableIdentifier() == id {
                return item
            }
        }
        
        return nil
    }
   ```
    
   - **Get Source ViewController For PickerView to be presented on:** In this method return the super view controller to present the picker data list Viewcontroller (Popover view controller)
   ```swift
        func sourceViewControllerForPickerView() -> UIViewController {
            return self
        }
   ```

   - **Height For Picker View Controller :** Optional method to return the height of data picker list.

     ```swift
        func heightForPickerView() -> CGFloat {
            return 100.0
        }
     ``` 
     
   - **Custom Picker TableViewCell:** Optional method to return your custom **UITableViewCell** for the data picker list, if didn't implement this method we use our TableViewCell.

    ```swift
        func cell(for item: JNMentionEntityPickable, tableView: UITableView) -> UITableViewCell {
            let cell = UITableViewCell()
            cell.textLabel?.text = item.getPickableTitle()
            return cell
        }
    ```
   
   ***Important To Register Your custom cell using this Method***:
       ```swift
         public func registerTableViewCell(_ nib: UINib?, forCellReuseIdentifier identifier: String) 
        }
    ```
   - **Height For Picker TableViewCell:** Optional method to return the height of **UITableViewCell** in the data picker list.

     ```swift
        func heightForCell(for item: JNMentionEntityPickable, tableView: UITableView) -> CGFloat {
            return 50.0
        }
     ``` 
     
 ## General Methods:
   - **Retrieve Mention List:**
    You can retrieve the list of mentioned items with their range (location, length) and special symbol string by calling the class method in the JNMentionTextView:

```swift
getMentionedItems(from attributedString: NSAttributedString, symbol: String = "") 
-> [JNMentionEntity]
```

   - **Get Smart Replacement:**
Used to retrieve smart attributed string (encrich string with mention annotations) from a simple string contains special    characters with unique pickable ids  

```swift
getSmartReplacement(text: String, data: [String: [JNMentionPickable]], normalAttributes: [NSAttributedString.Key: Any],       mentionReplacements: [String: [NSAttributedString.Key : Any]]) 
-> NSAttributedString
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Jayel Zaghmoutt, Mohammad Nabulsi & Mohammad Ihmouda

## License

JNMentionTextView is available under the MIT license. See the [LICENSE](https://github.com/JNDisrupter/JNMentionTextView/blob/master/LICENSE) file for more info.
