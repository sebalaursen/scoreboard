//
//  ViewController.swift
//  scoreboard
//
//  Created by Sebastian on /15/6/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

fileprivate enum ScoreboardState {
    case running, finished, paused, clear
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var leftNameLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    @IBOutlet weak var rightNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    fileprivate var currentState = ScoreboardState.clear {
        willSet {
            stateDidChange(with: newValue)
        }
    }
    
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
    }
}

// MARK: - Actions

extension MainViewController {
    
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
    
    @IBAction func start(_ sender: UIButton) {
        switch  sender.tag {
        case 0:
            currentState = .running
            sender.tag = 1
        default:
            currentState = .paused
            sender.tag = 0
        }
        
    }
    
    @IBAction func reset(_ sender: UIButton) {
        currentState = .clear
    }
}

// MARK: - Scoreboard State

extension MainViewController {
    
    private func stateDidChange(with state: ScoreboardState) {
        switch state {
            
        case .running:
            continueScore()
        case .finished:
            finishFight()
        case .paused:
            pauseScore()
        case .clear:
            resetScore()
        }
    }
    
    private func finishFight() {
        
    }
    
    private func resetScore() {
        startButton.setTitle("Start", for: .normal)
    }
    
    private func pauseScore() {
        startButton.setTitle("Continue", for: .normal)
    }
    
    private func continueScore() {
        startButton.setTitle("Pause", for: .normal)
    }
}
