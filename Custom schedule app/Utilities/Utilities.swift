//
//  Utilities.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 20/9/24.
//

import Foundation
class TimeUtilities {
     func convertUnixTimeToDictionary(unixTime: Int) -> TimeModel {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let calendar = Calendar.current
        
        // Extract components of the date
        let hour = calendar.component(.hour, from: date)
        let day = String(calendar.component(.day, from: date))
        let month = String (calendar.component(.month, from: date))
        let year = String (calendar.component(.year, from: date))

        
        return TimeModel(hour: hour, day: day, month: month, year: year)
    }
}
