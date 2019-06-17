//
//  FinishViewController.swift
//  scoreboard
//
//  Created by Sebastian on /17/6/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

protocol FinishDelegate: class {
    func cancelTapped()
    func rematchTappded()
}

class FinishViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    weak var delegate: FinishDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func rematchAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = -self.view.frame.height
        }) { (finished) in
            self.delegate?.rematchTappded()
            self.view.removeFromSuperview()
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.view.frame.height
        }) { (finished) in
            self.delegate?.cancelTapped()
            self.view.removeFromSuperview()
        }
    }
}
