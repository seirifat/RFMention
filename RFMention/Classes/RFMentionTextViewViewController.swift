//
//  RFMentionTextViewViewController.swift
//  RFMentionTextView
//
//  Created by Rifat Firdaus on 3/26/18.
//  Copyright © 2018 Ripatto. All rights reserved.
//

import UIKit

open class RFMentionItem {
    public var id: Int64 = 0
    public var text = ""
    public init(id:Int64 = 0, text: String = "") {
        self.id = id
        self.text = text
    }
}

struct MentionedItem {
    var id: Int64 = 0
    var text = ""
    var textAt = ""
    var range = NSRange()
}

open class RFMentionTextViewViewController: UIViewController {

    var textViewMention: UITextView = UITextView()
    var tableViewMention: UITableView!
    
    var rfMentionItems = [RFMentionItem]()
    private var rfMentionItemsFilter = [RFMentionItem]()
    private var tableViewMentionVConstraint = [NSLayoutConstraint]()
    
    var isTableHidden = true
    var isTextViewSearch = false
    var cellHeight = 44
    
    var mentionedItems = [MentionedItem]()
    private var currentMention = MentionedItem()
    
    var mentionAttributed: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor : UIColor.blue]
    var defaultAttributed: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]
    
    var searchString = ""
    
    private let tableWidth = Int(UIScreen.main.bounds.width)
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableViewMention = UITableView(frame: CGRect(x: 0, y: 0, width: tableWidth, height: cellHeight * rfMentionItems.count), style: UITableViewStyle.plain)
        view.addSubview(tableViewMention)
        tableViewMention.register(UITableViewCell.self, forCellReuseIdentifier: "defCell")
        tableViewMention.delegate = self
        tableViewMention.dataSource = self
        tableViewMention.isHidden = isTableHidden
        tableViewMention.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: METHODS
    
    public func setUpMentionTextView(textView: UITextView, itemList: [RFMentionItem]) {
        textViewMention = textView
        rfMentionItems = itemList
        rfMentionItemsFilter = rfMentionItems
        textViewMention.delegate = self
        reloadViewTable()
        mentionedItems = [MentionedItem]()
        textViewMention.attributedText = NSAttributedString(string: " ", attributes: defaultAttributed)
        
        let views: [String: Any] = [
            "textViewMention": textViewMention,
            "tableViewMention": tableViewMention
        ]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        let tableViewMentionHConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[tableViewMention]-0-|",
            metrics: nil,
            views: views)
        allConstraints += tableViewMentionHConstraint
        
        var tableHeight = rfMentionItemsFilter.count * cellHeight
        if rfMentionItems.count > 5 {
            tableHeight = cellHeight * 5
        }
        
        tableViewMentionVConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[tableViewMention(\(tableHeight))]-(-\(tableHeight))-[textViewMention]",
            metrics: nil,
            views: views)
        allConstraints += tableViewMentionVConstraint
        NSLayoutConstraint.activate(allConstraints)
    }
    
    private func reloadViewTable() {
        tableViewMention.contentInset = UIEdgeInsetsMake(4, 0, 4, 0)
        tableViewMention.reloadData()
    }
    
    private func showList() {
        if self.isTableHidden == true {
            self.tableViewMentionVConstraint[1].constant = 0
            UIView.transition(with: tableViewMention, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.tableViewMention.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.isTableHidden = false
            })
        }
    }
    
    private func hideList() {
        if self.isTableHidden == false {
            let tableHeight = rfMentionItemsFilter.count * cellHeight
            self.tableViewMentionVConstraint[1].constant = -CGFloat(tableHeight)
            UIView.transition(with: tableViewMention, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.tableViewMention.isHidden = true
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.isTableHidden = true
            })
        }
    }
    
    private func searchText(searchString: String?) {
        let searchString = searchString ?? ""
//        print(searchString)
        if searchString != "" {
            rfMentionItemsFilter = rfMentionItems.filter({ item -> Bool in
                return item.text.lowercased().contains(searchString.lowercased())
            })
        } else {
            rfMentionItemsFilter = rfMentionItems
        }
        let tableHeight = rfMentionItemsFilter.count * cellHeight
        self.tableViewMentionVConstraint[0].constant = CGFloat(tableHeight)
        self.tableViewMention.reloadData()
    }
    
}

// MARK: UITABLEVIEW DELEGATE DATASOURCE

extension RFMentionTextViewViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Datasource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rfMentionItemsFilter.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defCell", for: indexPath)
        cell.textLabel?.text = rfMentionItemsFilter[indexPath.row].text
        return cell
    }
    
    // Delegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        isTextViewSearch = false
        searchString = ""
        
        
        let mutableAttributed = NSMutableAttributedString()
        mutableAttributed.append(textViewMention.attributedText)
        
        var attributesStyle = mentionAttributed
        attributesStyle[NSAttributedStringKey.font] = textViewMention.font
        
        currentMention.id = rfMentionItemsFilter[indexPath.row].id
        currentMention.text = rfMentionItemsFilter[indexPath.row].text
        currentMention.textAt = "@" + currentMention.text
        currentMention.range = NSMakeRange(currentMention.range.location, currentMention.textAt.count)
        
        mentionedItems.append(currentMention)
        
        let mentionedText = NSAttributedString(string: currentMention.textAt, attributes: attributesStyle)
        
        if let selectedRange = textViewMention.selectedTextRange {
            mutableAttributed.replaceCharacters(in: NSMakeRange(currentMention.range.location, searchString.count + 1), with: NSAttributedString(string: ""))
            let cursorPosition = textViewMention.offset(from: textViewMention.beginningOfDocument, to: selectedRange.start)
//            print("\(cursorPosition)")
            mutableAttributed.insert(mentionedText, at: cursorPosition - 1)
            mutableAttributed.insert(NSAttributedString(string: " ", attributes: defaultAttributed), at: cursorPosition + rfMentionItemsFilter[indexPath.row].text.count)
            mutableAttributed.addAttributes(defaultAttributed, range: NSMakeRange(cursorPosition, 0))
        }
        
//        mutableAttributed.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.yellow, range: currentMention.range)
        
        textViewMention.attributedText = mutableAttributed
        
//        print(currentMention)
        
        textViewMention.selectedRange = NSMakeRange(currentMention.range.location + currentMention.textAt.count + 1, 0)
        
        self.hideList()
    }
    
}

// MARK: UITEXTVIEW DELEGATE

extension RFMentionTextViewViewController: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        print(range)
        
        if text != "" && range.location - 1 >= 0 {
            let mutableAttributed = NSMutableAttributedString()
            mutableAttributed.append(textViewMention.attributedText)
            mutableAttributed.addAttributes(defaultAttributed, range: NSMakeRange(range.location - 1, 1))
            textViewMention.attributedText = mutableAttributed
        }
        
        if isTextViewSearch == false {
            if text == "" {
                if mentionedItems.count > 0 {
                    for idx in 0 ..< mentionedItems.count {
                        if mentionedItems[idx].range.location...mentionedItems[idx].range.location + mentionedItems[idx].range.length - 1 ~= range.location {
                            let mutableAttributed = NSMutableAttributedString()
                            mutableAttributed.append(textViewMention.attributedText)
                            mutableAttributed.replaceCharacters(in: mentionedItems[idx].range, with: NSAttributedString(string: ""))
                            textViewMention.attributedText = mutableAttributed
                            textViewMention.selectedRange = NSMakeRange(mentionedItems[idx].range.location, 0)
                            
                            for idxOther in 0 ..< mentionedItems.count {
                                if idx != idxOther {
                                    if mentionedItems[idxOther].range.location > mentionedItems[idx].range.location {
                                        mentionedItems[idxOther].range.location = mentionedItems[idxOther].range.location - mentionedItems[idx].range.length
                                    }
                                }
                            }
                            
                            mentionedItems.remove(at: idx)
                            
                            return false
                        } else if mentionedItems[idx].range.location > range.location {
                            mentionedItems[idx].range.location -= 1
                        }
                    }
                }
                
                isTextViewSearch = false
                searchString = ""
                rfMentionItemsFilter = rfMentionItems
                tableViewMention.reloadData()
                return true
            } else {
                for idx in 0 ..< mentionedItems.count {
                    if mentionedItems[idx].range.location > range.location {
                       mentionedItems[idx].range.location += 1
                    }
                }
            }
        }
        if text == "@" {
            currentMention = MentionedItem(id: 0, text: "", textAt: "@", range: range)
            let tableHeight = rfMentionItemsFilter.count * cellHeight
            self.tableViewMentionVConstraint[0].constant = CGFloat(tableHeight)
            isTextViewSearch = true
            rfMentionItemsFilter = rfMentionItems
            tableViewMention.reloadData()
            self.showList()
        } else if isTextViewSearch {
            if text == "" {
                if searchString.count > 0 {
                    searchString.removeLast()
                    searchText(searchString: searchString)
                } else {
                    isTextViewSearch = false
                    self.hideList()
                }
            } else {
                searchString += text
                searchText(searchString: searchString)
            }
        }
        return true
    }
    
}
