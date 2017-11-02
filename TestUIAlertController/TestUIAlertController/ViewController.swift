//
//  ViewController.swift
//  TestUIAlertController
//
//  Created by ST21235 on 2017/11/02.
//  Copyright © 2017 He Wu. All rights reserved.
//

import UIKit
import Foundation

private extension UIColor {
//    class var lineGreen: UIColor { return UIColor(rgb: 0x00D059) }
//    class var counterText: UIColor { return UIColor(rgb: 0x828897) }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func popupUI(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Skip this item?",
                                                message: "Once set, you can\'t revert any changes.",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Skip", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Never mind", style: .cancel, handler: nil))


        
    }


}

