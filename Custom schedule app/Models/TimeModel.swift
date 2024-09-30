//
//  Time.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 20/9/24.
//

import Foundation

class Time{
    var hour : Int
    var day: Int
    var month : Int
    
    init(hour: Int, day: Int, month: Int) {
        self.hour = hour
        self.day = day
        self.month = month
    }
    
    func description() -> String {
          return "Hour: \(hour), Day: \(day), Month: \(month)"
      }
}
