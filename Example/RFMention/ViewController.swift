//
//  ViewController.swift
//  RFMentionDemo
//
//  Created by Rifat Firdaus on 3/26/18.
//  Copyright © 2018 Ripatto. All rights reserved.
//

import UIKit
import RFMention

class ViewController: RFMentionTextViewViewController {
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alam = RFMentionItem(id: 1, text: "Alam Muh")
        let bungkhus = RFMentionItem(id: 2, text: "Bungkhus")
        let dodi = RFMentionItem(id: 2, text: "Dodi Dar")
        let rifki = RFMentionItem(id: 2, text: "Rifki")
        let aldi = RFMentionItem(id: 2, text: "Aldi Fir")
        self.setUpMentionTextView(textView: textView, itemList: [
            alam,
            bungkhus,
            dodi,
            rifki,
            aldi
            ])
    }


}

