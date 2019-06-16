//
//  ViewController.swift
//  scoreboard
//
//  Created by Sebastian on /15/6/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var leftScore: UILabel!
    @IBOutlet weak var rightScore: UILabel!
    private var currentLeftScore = 0
    private var currentRightScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
    }
    
    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(handleHold(sender:)))
        let hold1 = UILongPressGestureRecognizer(target: self, action: #selector(handleHold(sender:)))
        
        leftScore.addGestureRecognizer(tap)
        leftScore.addGestureRecognizer(hold)
        rightScore.addGestureRecognizer(tap1)
        rightScore.addGestureRecognizer(hold1)
        
        leftScore.isUserInteractionEnabled = true
        rightScore.isUserInteractionEnabled = true
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
        guard let score = sender.view as! UILabel? else {
            return
        }
        var current = Int(score.text!)!
        current -= 1
        score.text = "\(current)"
    }


}
