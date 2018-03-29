# RFMention

[![CI Status](http://img.shields.io/travis/seirifat/RFMention.svg?style=flat)](https://travis-ci.org/seirifat/RFMention)
[![Version](https://img.shields.io/cocoapods/v/RFMention.svg?style=flat)](http://cocoapods.org/pods/RFMention)
[![License](https://img.shields.io/cocoapods/l/RFMention.svg?style=flat)](http://cocoapods.org/pods/RFMention)
[![Platform](https://img.shields.io/cocoapods/p/RFMention.svg?style=flat)](http://cocoapods.org/pods/RFMention)

## USAGE

1. Import header

```ruby
import RFMention
```
2. Create RFMentionViewController in your ViewController

```ruby
let rfController = RFMentionTextViewViewController()
```

3. Create array of `RFMentionItem` and passing to `setUpMentionTextView`

```ruby
var itemsArray: [RFMentionItem]  = [RFMentionItem]()

let alam = RFMentionItem(id: 1, text: "Alam Muh")
let bungkhus = RFMentionItem(id: 2, text: "Bungkhus")
let dodi = RFMentionItem(id: 2, text: "Dodi Dar")
let rifki = RFMentionItem(id: 2, text: "Rifki")
let aldi = RFMentionItem(id: 2, text: "Aldi Fir")

itemsArray.append(alam)
itemsArray.append(bungkhus)
itemsArray.append(dodi)
itemsArray.append(rifki)
itemsArray.append(aldi)

// parentController is this view controller
rfController.setUpMentionTextView(parentController: self, textView: textView, itemList: itemsArray)
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RFMention is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RFMention'
```

## Author

seirifat, garu.okigaru@gmail.com

## License

RFMention is available under the MIT license. See the LICENSE file for more info.
