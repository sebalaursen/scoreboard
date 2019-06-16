//
//  NamingViewController.swift
//  scoreboard
//
//  Created by Sebastian on /16/6/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class NamingViewController: UIViewController {
    @IBOutlet weak var leftNameTF: UITextField!
    @IBOutlet weak var rightNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NamingViewController {
    @IBAction func doneAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.x = self.view.frame.width
        }) { (finished) in
            self.view.removeFromSuperview()
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.x = self.view.frame.width
        }) { (finished) in
            self.view.removeFromSuperview()
        }
    }
}
