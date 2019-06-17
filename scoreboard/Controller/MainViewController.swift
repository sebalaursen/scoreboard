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
    @IBOutlet weak var reverseButton: UIButton!
    @IBOutlet weak var scoreStackView: UIStackView!
    
    fileprivate lazy var namePopUp = NamingViewController.instantiate()
    fileprivate lazy var finishPopUp = FinishViewController.instantiate()
    
    fileprivate var currentState = ScoreboardState.clear {
        willSet {
            stateDidChange(with: newValue)
        }
    }

    weak var timer: Timer?
    private var secondsRemain = Settings.secondTimeForRound

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentState = .clear
        showNamingPopUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        
        namePopUp.removeFromParent()
        finishPopUp.removeFromParent()
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
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let score = sender.view as! UILabel? else {
            return
        }
        guard var current = Int(score.text ?? "0") else { return }
        
        if current >= Settings.maxPoint {
            self.currentState = .finished
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
            guard var current = Int(score.text ?? "0") else { return }
            current -= 1
            score.text = "\(current)"
        }
    }
}

// MARK: - Actions

extension MainViewController {
    
    private func showNamingPopUp() {
        self.addChild(namePopUp)
        namePopUp.delegate = self
        namePopUp.view.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width, height: view.frame.height)
        self.view.addSubview(namePopUp.view)

        UIView.animate(withDuration: 0.3) {
            self.namePopUp.view.frame.origin.x = 0
        }
    }
    
    private func showFinishPopUp(title: String, leftScore: String, rightScore: String) {
        finishPopUp.delegate = self
        self.addChild(finishPopUp)
        self.view.addSubview(finishPopUp.view)
        
        finishPopUp.titleLabel.text = title
        finishPopUp.leftScoreLabel.text = leftScore
        finishPopUp.rightScoreLabel.text = rightScore
        
        UIView.animate(withDuration: 0.25, animations: {
            self.finishPopUp.view.frame.origin.y = 10
        }) { (finished) in
            UIView.animate(withDuration: 0.09, animations: {
                self.finishPopUp.view.frame.origin.y = -7
            }) { (finished) in
                UIView.animate(withDuration: 0.06) {
                    self.finishPopUp.view.frame.origin.y = 0
                }
            }
        }
    }
    
    @IBAction func scoreReverse(_ sender: Any) {
        
        if leftScore != rightScore {
            UIView.animate(withDuration: 0.4, animations: {
                self.scoreStackView.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.reverseButton.alpha = 0
            }) { finished in
                self.reverseButton.alpha = 1
                self.scoreStackView.transform = .identity
                let leftScoreTemp = self.leftScore
                self.leftScoreLabel.text = String(self.rightScore)
                self.rightScoreLabel.text = String(leftScoreTemp)
            }
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
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) {
            _ in self.currentState = .clear
            self.showNamingPopUp()
        }
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
        var currentLeftScore = leftScore
        var currentRightScore = rightScore
        
        currentLeftScore += 1
        currentRightScore += 1
        
        self.leftScoreLabel.text = "\(currentLeftScore)"
        self.rightScoreLabel.text = "\(currentRightScore)"
        
        if currentRightScore >= Settings.maxPoint || currentLeftScore >= Settings.maxPoint {
            currentState = .finished
        }
    }
}

// MARK: - Scoreboard State

extension MainViewController {
    
    var leftScore: Int {
        return Int(leftScoreLabel.text ?? "0") ?? 0
    }
    
    var rightScore: Int {
        return Int(rightScoreLabel.text ?? "0") ?? 0
    }
    
    var finishTitle: String {
        let winnerName = leftScore > rightScore ? leftNameLabel.text : rightNameLabel.text
        return leftScore == rightScore ? "Draw!" : "\(winnerName ?? "") has won!"
    }
    
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
        showFinishPopUp(title: finishTitle, leftScore: String(leftScore), rightScore: String(rightScore))
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

// MARK: - Naming  & Finish Delegate

extension MainViewController: NamingDelegate, FinishDelegate {
    
    func cancelTapped() {
        currentState = .clear
        showNamingPopUp()
    }
    
    func rematchTappded() {
        currentState = .clear
    }
    
    func getName(leftName: String, rightName: String) {
        self.leftNameLabel.text = leftName
        self.rightNameLabel.text = rightName
    }
}
