//
//  ViewController.swift
//  StrikethroughLabelSample
//
//  Created by Charles Prado on 08/04/20.
//  Copyright © 2020 Charles Prado. All rights reserved.
//

import UIKit
import StrikethroughLabel

class ViewController: UIViewController {

    var label = StrikethroughLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.numberOfLines = 0
        view.addSubview(label)
        label.frame = CGRect(x: 20, y: view.center.y, width: UIScreen.main.bounds.width * 0.9, height: 41)
        label.text = "The sky above the port was the colour of television, tuned to a dead channel."
    }

    @IBAction func notReadActioon(_ sender: Any) {
        label.hideStrikeTextLayer()
    }
    
    @IBAction func readAction(_ sender: Any) {
        label.strikeThroughText()
    }
}

