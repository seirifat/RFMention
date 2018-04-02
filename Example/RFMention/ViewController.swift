//
//  ViewController.swift
//  RFMentionDemo
//
//  Created by Rifat Firdaus on 3/26/18.
//  Copyright © 2018 Ripatto. All rights reserved.
//

import UIKit
import RFMention

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var constraintBottom: NSLayoutConstraint!
    
    let rfController = RFMentionTextViewViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        
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
        
        rfController.setUpMentionTextView(parentController: self, textView: textView, itemList: itemsArray)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotif(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotif(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }


    @IBAction func buttonSubmitPressed(_ sender: Any) {
        var people = "\n"
        rfController.mentionedItems.forEach { item in
            people.append(contentsOf: item.text)
            people.append(contentsOf: "\n")
        }
        let alert = UIAlertController(title: "Tagged People", message: people, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleKeyboardNotif(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let isKeyboardShow = notification.name == Notification.Name.UIKeyboardWillShow
            
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            print(keyboardFrame)
            constraintBottom.constant = isKeyboardShow ? keyboardFrame.height : 0
            print(constraintBottom.constant)
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            })
            tableView.scrollToRow(at: IndexPath(row: 54, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(rfController.mentionedItems)")
    }
    
}
