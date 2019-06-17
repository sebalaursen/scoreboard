//
//  NamingViewController.swift
//  scoreboard
//
//  Created by Sebastian on /16/6/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

protocol NamingDelegate: class {
    func getName(leftName: String, rightName: String)
}

class NamingViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var leftNameTF: UITextField!
    @IBOutlet weak var rightNameTF: UITextField!
    
    weak var delegate: NamingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NamingViewController {
    
    @IBAction func doneAction(_ sender: Any) {
        if leftNameTF.text != "" && rightNameTF.text != "" {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame.origin.x = self.view.frame.width
            }) { (finished) in
                self.delegate?.getName(leftName: self.leftNameTF.text!, rightName: self.rightNameTF.text!)
                self.view.removeFromSuperview()
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.view.frame.origin.x += 9
                self.leftNameTF.layer.borderColor = UIColor.red.cgColor
                self.rightNameTF.layer.borderColor = UIColor.red.cgColor
            }) { (finished) in
                UIView.animate(withDuration: 0.16, animations: {
                    self.view.frame.origin.x -= 18
                }) { (finished) in
                    UIView.animate(withDuration: 0.1) {
                        self.leftNameTF.layer.borderColor = UIColor.black.cgColor
                        self.rightNameTF.layer.borderColor = UIColor.black.cgColor
                        self.view.frame.origin.x += 9
                    }
                }
            }
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

// MARK: - Text Field Delegate

extension NamingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

