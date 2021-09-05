//
//  Created by Анастасия Горячевская on 05.09.2021.
//

import Foundation

class TimerTask {
    let name: String
    var timerDate = Date()
    var completed = false
    
    init(name: String, date: Date) {
        self.name = name
        self.timerDate = date
    }
    
    func reduceTime() {
        let timeNull = DateComponents(second: 0)
        let calendar = Calendar.current
        let date0 = calendar.date(from: timeNull)!
        
        if timerDate == date0 {
            completed = true
        } else {
            timerDate.addTimeInterval(-1)
        }
    }
}
