//
//  BasicTest.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 6/2/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import Foundation
import UIKit

class Tests {
    public func toTimeStamp(time: TimeInterval) -> String {
        let timeint = time
        let day = TimeInterval(60 * 60 * 24.0)
        let now = Date().timeIntervalSince1970
        
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        
        let calendar = Calendar(identifier: .gregorian)
        
        let morning = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let morningInt = morning!.timeIntervalSince1970
        
        let yesterdayTimeInt = now - day
        let yesterdayDate = Date(timeIntervalSince1970: yesterdayTimeInt)
        let yesterday = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: yesterdayDate)
        let yesterdayInt = yesterday!.timeIntervalSince1970
        
        var timestamp = ""
        
        if timeint > morningInt {
            formatter.dateStyle = .none
            let date = Date(timeIntervalSince1970: timeint)
            let str = formatter.string(from: date)
            timestamp = "Today, \(str)"
        } else if timeint < morningInt && timeint > yesterdayInt {
            formatter.dateStyle = .none
            let date = Date(timeIntervalSince1970: timeint)
            let str = formatter.string(from: date)
            timestamp = "Yesterday, \(str)"
        } else if timeint < yesterdayInt {
            let date = Date(timeIntervalSince1970: timeint)
            let str = formatter.string(from: date)
            formatter.dateFormat = "MMM dd"
            let dateStr = formatter.string(from: date)
            timestamp = "\(dateStr), \(str)"
        }
        
        return timestamp
        
    }
}
