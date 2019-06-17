# JNMentionTextView

[![CI Status](https://img.shields.io/travis/ihmouda/JNMentionTextView.svg?style=flat)](https://travis-ci.org/ihmouda/JNMentionTextView)
[![Version](https://img.shields.io/cocoapods/v/JNMentionTextView.svg?style=flat)](https://cocoapods.org/pods/JNMentionTextView)
[![License](https://img.shields.io/cocoapods/l/JNMentionTextView.svg?style=flat)](https://cocoapods.org/pods/JNMentionTextView)
[![Platform](https://img.shields.io/cocoapods/p/JNMentionTextView.svg?style=flat)](https://cocoapods.org/pods/JNMentionTextView)

**JNMentionTextView** is a UITextView drop-in replacement supporting special characters such as [ #, @ ] and regex patterns, written in Swift. **JNMentionTextView** is a custom easy to use UITextView providing powerful tool and supportting for creating **‘Mention’** annotations in to your iOS app. Annotations which refers to names of individuals or entities and treated as a single unit and can be styled differently from the rest of the text.



## Preview

<img src="https://github.com/JNDisrupter/JNMentionTextView/raw/master/Images/mention-1.gif" width="280"/> 
<img src="https://github.com/JNDisrupter/JNMentionTextView/raw/master/Images/mention-2.gif" width="280"/> 

## Requirements:

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

- Import **JNMentionTextView module**
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
- ***JNMentionTextView Setup:***

```swift
self.textView.setup(options: JNMentionOptions()
```

- **Options Customization:**
Customize the data list apperance (Picker View):

- **borderColor**: picker view border color.
- **borderWitdth**: picker view border width.
- **backgroundColor**: picker view background color.
- **listViewBackgroundColor**: table list view background color.
- **pickerViewHeight**: picker view height.
- **viewMode**: support two view modes:
- **Top**
- **Bottom**
The view mode can has an accessory view as a triangle to indicate the position of typing with specifying the triangle length float value.
- **mentionReplacements**: A dictionary of replacement strings with the their corresponding style.
- **normalAttributes**: normal Attributes:

```swift
JNMentionOptions(
borderColor: UIColor.gray,
borderWitdth: 1.0, 
backgroundColor: UIColor.clear,
listViewBackgroundColor: UIColor.white,
pickerViewHeight: 100.0,
viewMode: JNMentionViewMode.bottom(JNMentionViewMode.accessoryView.triangle(length: 15.0)),
mentionReplacements: ["@": [NSAttributedString.Key.foregroundColor: UIColor.blue,
NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]],
normalAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
)
```
-  **Mention Data List:**
The list of entities that you can select must be class / struct the confirms to the **JNMentionEntityPickable** protocol by implementing his three methods:
**1. getPickableTitle:** return the title of entities which you can select.
```swift
getPickableTitle() -> String
```

**2. getPickableIdentifier:** used to uniquely identify the entities - Entity id -.

```swift
getPickableIdentifier() -> String
```

- **JNMentionTextViewDelegate:**

Your class must use the **JNMentionTextViewDelegate** Protocol and conform to it by implementing the three required methods in **JNMentionTextViewDelegate**:

- **retrieveData:** In this method retrieve list of **JNMentionEntityPickable** objects that the user can select for the provided search string and special symbol.
```swift
func retrieveDataFor(_ symbole: String, using searchTerm: String) -> [JNMentionEntityPickable] {
var data = self.data[symbole] ?? []
if !searchTerm.isEmpty {
data = data.filter({ $0.getPickableTitle().contains(searchTerm)})
}
return data
}
```
- **Cell:** In this method return **UITableViewCell** for **JNMentionEntityPickable** entity that the user can select.

```swift
func cell(for item: JNMentionEntityPickable, tableView: UITableView) -> UITableViewCell {
let cell = UITableViewCell()
cell.textLabel?.text = item.getPickableTitle()
return cell
}
```
- **heightForCell:** In this method return height of **UITableViewCell** for JNMentionEntityPickable entity that the user can select.

```swift
func heightForCell(for item: JNMentionEntityPickable, tableView: UITableView) -> CGFloat {
return 50.0
}
```    
- ***Retrieve Mention List:***

You can retrieve the list of mentioned items with their range (location, length) and special symbol string by calling the method:

```swift
getMentionedItems(for symbol: String) -> [JNMentionEntity] 
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Jayel Zaghmoutt, Mohammad Nabulsi & Mohammad Ihmouda

## License

JNMentionTextView is available under the MIT license. See the [LICENSE](https://github.com/JNDisrupter/JNMentionTextView/blob/master/LICENSE) file for more info.
