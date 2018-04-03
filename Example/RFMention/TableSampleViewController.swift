//
//  TableSampleViewController.swift
//  RFMention_Example
//
//  Created by Rifat Firdaus on 4/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class TableSampleViewController: UIViewController {

    static func instantiate() -> UINavigationController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sampleNav") as! UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func buttonDonePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
