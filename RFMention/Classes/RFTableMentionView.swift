//
//  RFTableMentionView.swift
//  Pods-RFMention_Example
//
//  Created by Rifat Firdaus on 4/3/18.
//

import UIKit
import Foundation

open class RFMentionItem {
    open var id: Int64 = 0
    open var text = ""
    public init(id:Int64 = 0, text: String = "") {
        self.id = id
        self.text = text
    }
}

public struct MentionedItem {
    public var id: Int64 = 0
    public var text = ""
    public var textAt = ""
    public var range = NSRange()
}

open class RFTableMentionView: UIView {
    
    var textViewMention: UITextView = UITextView()
    var tableViewMention: UITableView!
    
    var rfMentionItems = [RFMentionItem]()
    private var rfMentionItemsFilter = [RFMentionItem]()
    private var tableViewMentionVConstraint = [NSLayoutConstraint]()
    
    var isTableHidden = true
    var isTextViewSearch = false
    var cellHeight = 44
    
    public var mentionedItems = [MentionedItem]()
    private var currentMention = MentionedItem()
    
    var mentionAttributed: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor : UIColor.blue]
    var defaultAttributed: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]
    
    var searchString = ""
    
    private let tableWidth = Int(UIScreen.main.bounds.width)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        tableViewMention = UITableView(frame: frame, style: UITableViewStyle.plain)
        self.addSubview(tableViewMention)
        tableViewMention.register(UITableViewCell.self, forCellReuseIdentifier: "defCell")
        tableViewMention.delegate = self
        tableViewMention.dataSource = self
        tableViewMention.isHidden = isTableHidden
        tableViewMention.translatesAutoresizingMaskIntoConstraints = false
        textViewMention.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        tableViewMention.isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }

    // MARK: METHODS
    
    public func setUpMentionTextView(parentController: UIViewController, textView: UITextView, itemList: [RFMentionItem]) {
        self.backgroundColor = UIColor.clear
        parentController.view.addSubview(self)
        parentController.view.bringSubview(toFront: self)
        
        textViewMention = textView
        rfMentionItems = itemList
        rfMentionItemsFilter = rfMentionItems
        textViewMention.delegate = self
        reloadViewTable()
        mentionedItems = [MentionedItem]()
        textViewMention.attributedText = NSAttributedString(string: " ", attributes: defaultAttributed)
        
        var tableHeight = rfMentionItemsFilter.count * cellHeight
        if rfMentionItems.count > 5 {
            tableHeight = cellHeight * 5
        }
        _ = self.addConstraintsWithFormat("H:|-0-[v0]-0-|", views: self)
        _ = self.addConstraintsWithFormat("V:|-0-[v0]-0-|", views: self)
        _ = self.addConstraintsWithFormat("H:|-0-[v0]-0-|", views: tableViewMention)
        tableViewMentionVConstraint = self.addConstraintsWithFormat("V:[v0(\(tableHeight))]-(-\(tableHeight))-[v1]", views: tableViewMention,textViewMention)
        
    }
    
    private func reloadViewTable() {
        tableViewMention.contentInset = UIEdgeInsetsMake(4, 0, 4, 0)
        tableViewMention.reloadData()
    }
    
    private func showList() {
        self.isUserInteractionEnabled = true
        if self.isTableHidden == true {
            self.tableViewMentionVConstraint[1].constant = 0
            UIView.transition(with: tableViewMention, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.tableViewMention.isHidden = false
                self.layoutIfNeeded()
            }, completion: { _ in
                self.isTableHidden = false
            })
        }
    }
    
    private func hideList() {
        self.isUserInteractionEnabled = false
        rfMentionItemsFilter = rfMentionItems
        if self.isTableHidden == false {
            let tableHeight = rfMentionItemsFilter.count * cellHeight
            self.tableViewMentionVConstraint[1].constant = -CGFloat(tableHeight)
            UIView.transition(with: tableViewMention, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.tableViewMention.isHidden = true
                self.layoutIfNeeded()
            }, completion: { _ in
                self.isTableHidden = true
            })
        }
    }
    
    private func searchText(searchString: String?) {
        let searchString = searchString ?? ""
        print(searchString)
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
//        if rfMentionItemsFilter.count <= 0 {
        if self.searchString.contains(" ") {
            self.searchString = ""
            self.isTextViewSearch = false
            self.hideList()
            self.isUserInteractionEnabled = false
        }
    }
    
    private func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    private func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
}

// MARK: UITABLEVIEW DELEGATE DATASOURCE

extension RFTableMentionView: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let mutableAttributed = NSMutableAttributedString()
        mutableAttributed.append(textViewMention.attributedText)
        
        var attributesStyle = mentionAttributed
        attributesStyle[NSAttributedStringKey.font] = textViewMention.font
        
        currentMention.id = rfMentionItemsFilter[indexPath.row].id
        currentMention.text = rfMentionItemsFilter[indexPath.row].text
        currentMention.textAt = "@" + currentMention.text
        
        let mentionedText = NSAttributedString(string: currentMention.textAt, attributes: attributesStyle)
        
        if let selectedRange = textViewMention.selectedTextRange {
            let cursorPosition = textViewMention.offset(from: textViewMention.beginningOfDocument, to: selectedRange.start)
            mutableAttributed.insert(mentionedText, at: cursorPosition)
            mutableAttributed.insert(NSAttributedString(string: " ", attributes: defaultAttributed), at: cursorPosition + rfMentionItemsFilter[indexPath.row].text.count + 1)
            mutableAttributed.replaceCharacters(in: NSMakeRange(currentMention.range.location, searchString.count + 1), with: NSAttributedString(string: ""))
        }
        
        searchString = ""
        currentMention.range = NSMakeRange(currentMention.range.location, currentMention.textAt.count)
        
        mentionedItems.append(currentMention)
        
        textViewMention.attributedText = mutableAttributed
        textViewMention.selectedRange = NSMakeRange(currentMention.range.location + currentMention.textAt.count + 1, 0)
        
        self.hideList()
    }
    
}

// MARK: UITEXTVIEW DELEGATE

extension RFTableMentionView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text != "" && range.location - 1 >= 0 && !encode(text).contains("\\u") {
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
        if text == "@" && isTextViewSearch == false {
            currentMention = MentionedItem(id: 0, text: "", textAt: "@", range: range)
            rfMentionItemsFilter = rfMentionItems
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


extension RFTableMentionView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) -> [NSLayoutConstraint] {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewsDictionary)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
