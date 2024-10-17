//
//  Time.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 20/9/24.
//

import Foundation

struct TimeModel : Hashable{
    var hour: Int
    var endHour: Int? = nil
    var day: String
    var month : String
    var year : String
    
    
    init(hour: Int, day: String, month: String, year : String, endHour: Int? = nil) {
        self.hour = hour
        self.day = day
        self.month = month
        self.year = year
        self.endHour = endHour
        
    }
}
//extension to make timeModel instances able to be compared
extension TimeModel: Equatable {
    static func ==(lhs: TimeModel, rhs: TimeModel) -> Bool {
        return
        lhs.day == rhs.day &&
        lhs.month == rhs.month &&
        lhs.year == rhs.year
    }
}
