//
//  TimerCell.swift
//  TimerTest
//
//  Created by Анастасия Горячевская on 03.09.2021.
//

import UIKit

class TimerCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    
    var timerTask: TimerTask? {
        didSet {
            name.text = timerTask?.name
            setState()
            updateTime()
        }
    }
    
    func updateState() {
        guard let task = timerTask else {
            return
        }
        task.completed.toggle()
        
        setState()
        updateTime()
    }
    
    func updateTime() {
        guard let task = timerTask else {
            return
        }
        
        if task.completed {
            time.text = "Completed"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            time.text = dateFormatter.string(from: timerTask!.timerDate)
            timerTask?.reduceTime()
        }
    }
    
    private func setState() {
        guard let task = timerTask else {
            return
        }
        
        if task.completed {
            name.attributedText = NSAttributedString(string: task.name,
                                                     attributes: [.strikethroughStyle: 1])
        } else {
            name.attributedText = NSAttributedString(string: task.name,
                                                     attributes: nil)
        }
    }
}
