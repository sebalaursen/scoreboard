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

    weak var timer: Timer?
    private var secondsRemain = Settings.secondTimeForRound

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentState = .clear
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
    
    private func showNamingPopUp() {
        let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NamingVC") as! NamingViewController
        self.addChild(popUp)
        popUp.view.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width, height: view.frame.height)
        self.view.addSubview(popUp.view)

        UIView.animate(withDuration: 0.3) {
            popUp.view.frame.origin.x = 0
        }
    }
    
    private func showFinishPopUp(title: String, leftScore: String, rightScore: String) {
        let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishViewController
        self.addChild(popUp)
        popUp.view.frame = CGRect(x: 0, y: -view.frame.height, width: view.frame.width, height: view.frame.height) //self.view.frame
        self.view.addSubview(popUp.view)
        
        UIView.animate(withDuration: 0.25, animations: {
            popUp.view.frame.origin.y = 10
        }) { (finished) in
            UIView.animate(withDuration: 0.09, animations: {
                popUp.view.frame.origin.y = -7
            }) { (finished) in
                UIView.animate(withDuration: 0.06) {
                    popUp.view.frame.origin.y = 0
                }
            }
        }
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let score = sender.view as! UILabel? else {
            return
        }
        var current = Int(score.text!)!
        
        if current == Settings.maxPoint {
            currentState = .finished
        } else {
            current += 1
            score.text = "\(current)"
        }
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
        switch  currentState {
        case .running:
            currentState = .paused
        default:
            currentState = .running
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        
        let enteredState = self.currentState
        currentState = .paused

        let alert = UIAlertController(title: nil, message: "Are you sure you want to reset score board ?", preferredStyle: .actionSheet)
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { _ in self.currentState = .clear }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            _ in if enteredState == .running {
                self.currentState = .running
            }
        }
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func doubleScoreTapped(_ sender: Any) {
        guard var currentLeftScore: Int = Int(self.leftScoreLabel?.text ?? "0") else { return }
        guard var currentRightScore: Int = Int(self.rightScoreLabel?.text ?? "0") else { return }
        
        currentLeftScore += 1
        currentRightScore += 1
        
        self.leftScoreLabel.text = "\(currentLeftScore)"
        self.rightScoreLabel.text = "\(currentRightScore)"
        
        if currentRightScore == Settings.maxPoint || currentLeftScore == Settings.maxPoint {
            currentState = .finished
        }
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
    
    private func continueScore() {
        startButton.setTitle("Pause", for: .normal)
        runTimer()
    }
    
    private func finishFight() {
        
    }
    
    private func pauseScore() {
        startButton.setTitle("Continue", for: .normal)
        timer?.invalidate()
    }
    
    private func resetScore() {
        startButton.setTitle("Start", for: .normal)
        leftScoreLabel.text = "0"
        rightScoreLabel.text = "0"
        DispatchQueue.main.async {
            self.timerLabel.text = TimeInterval(self.secondsRemain).stringFormatted()
        }
    
        finishTimer()
        secondsRemain = Settings.secondTimeForRound
    }
}

// MARK: - Timer

extension MainViewController {
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(MainViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsRemain < 1 {
            currentState = .finished
            finishTimer()
        } else {
            secondsRemain -= 1
            timerLabel.text = TimeInterval(secondsRemain).stringFormatted()
        }
    }
    
    private func finishTimer() {
        timer?.invalidate()
        timer = nil
    }
}
