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
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
