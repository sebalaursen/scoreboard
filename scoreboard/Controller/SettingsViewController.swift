//
//  SettingsViewController.swift
//  scoreboard
//
//  Created by Sebastian on /15/6/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var scoreTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    let times = ["1 minute", "2 minutes", "3 minutes", "4 minutes", "5 minutes", "6 minutes"]
    let points = ["5", "10", "15"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickers()
    }
    
    private func setupPickers() {
        let pointPicker = UIPickerView()
        pointPicker.delegate = self
        pointPicker.backgroundColor = .lightGray
        
        let timePicker = UIPickerView()
        timePicker.delegate = self
        timePicker.backgroundColor = .lightGray
        
        scoreTF.inputView = pointPicker
        timeTF.inputView = timePicker
        setUpToolbar()
    }
    
    func setUpToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.backgroundColor = UIColor.darkGray
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        scoreTF.inputAccessoryView = toolBar
        timeTF.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scoreTF.text = String(Settings.maxPoint)
        timeTF.text = "\(Settings.maxTime) minutes"
    }
    @objc func dismissPicker() {
        view.endEditing(true)
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == timeTF.inputView {
            return times.count
        }
        else {
            return points.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == timeTF.inputView {
            return times[row]
        }
        else {
            return points[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == timeTF.inputView {
            timeTF.text = times[row]
            if let num = timeTF.text!.components(separatedBy: " ").first {
                Settings.setMaxTime(Int(num)!)
            }
        }
        else {
            let point = points[row]
            scoreTF.text = point
            Settings.setMaxPoint(Int(point)!)
        }
    }
}
