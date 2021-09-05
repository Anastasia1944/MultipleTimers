//
//  ViewController.swift
//  TimerTest
//
//  Created by Анастасия Горячевская on 03.09.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerNameTextField: UITextField!
    @IBOutlet weak var timerTimePickerView: UIPickerView!
    @IBOutlet weak var timerTableView: UITableView!
    
    var hours = [String]()
    var mins = [String]()
    var secs = [String]()
    
    var timeSelected = DateComponents()
    
    var taskList: [TimerTask] = []
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerTimePickerView.dataSource = self
        timerTimePickerView.delegate = self
        
        timerTableView.delegate = self
        timerTableView.dataSource = self
        
        fillTimeArrays()
    }
    
    func fillTimeArrays(){
        for i in 0...60 {
            mins.append(String(i))
            secs.append(String(i))
            if i <= 24 {
                hours.append(String(i))
            }
        }
    }
    
    @IBAction func addTimerButton(_ sender: UIButton) {
        createTimer()
        DispatchQueue.main.async {
            let calendar = Calendar.current
            let date = calendar.date(from: self.timeSelected)!
            let task = TimerTask(name: self.timerNameTextField.text!, date: date)
            
            self.taskList.append(task)
            
            let indexPath = IndexPath(row: self.taskList.count - 1, section: 0)
            
            self.timerTableView.beginUpdates()
            self.timerTableView.insertRows(at: [indexPath], with: .top)
            self.timerTableView.endUpdates()
        }
    }
    
}

// MARK:- UIPickerView

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return mins.count
        case 2:
            return secs.count
        default:
            return 0
        }
    }
}

extension ViewController: UIPickerViewAccessibilityDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return hours[row]
        case 1:
            return mins[row]
        case 2:
            return secs[row]
        default: break
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            timeSelected.hour = Int(hours[row])!
        case 1:
            timeSelected.minute = Int(mins[row])!
        case 2:
            timeSelected.second = Int(secs[row])!
        default: break
        }
    }
}

//MARK:- UITableView

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TimerCell else {
            return
        }
        cell.updateState()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
        
        if let cell = cell as? TimerCell {
            cell.timerTask = taskList[indexPath.row]
        }
        
        return cell
    }
}

// MARK: - Timer
extension ViewController {
    @objc func updateTimer() {
        guard let visibleRowsIndexPaths = timerTableView.indexPathsForVisibleRows else {
            return
        }
        
        for indexPath in visibleRowsIndexPaths {
            if let cell = timerTableView.cellForRow(at: indexPath) as? TimerCell {
                cell.updateTime()
            }
        }
    }
    
    func createTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
}

