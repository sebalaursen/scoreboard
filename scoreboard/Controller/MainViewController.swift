//
//  ViewController.swift
//  scoreboard
//
//  Created by Sebastian on /15/6/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var leftNameLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    @IBOutlet weak var rightNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
    }
    
    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(handleHold(sender:)))
        let hold1 = UILongPressGestureRecognizer(target: self, action: #selector(handleHold(sender:)))
        
        leftScoreLabel.addGestureRecognizer(tap)
        leftScoreLabel.addGestureRecognizer(hold)
        rightScoreLabel.addGestureRecognizer(tap1)
        rightScoreLabel.addGestureRecognizer(hold1)
        
        leftScoreLabel.isUserInteractionEnabled = true
        rightScoreLabel.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let score = sender.view as! UILabel? else {
            return
        }
        var current = Int(score.text!)!
        current += 1
        score.text = "\(current)"
    }
    
    @objc private func handleHold(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            guard let score = sender.view as! UILabel?, score.text != "0" else {
                return
            }
            var current = Int(score.text!)!
            current -= 1
            score.text = "\(current)"
        }
    }


}

