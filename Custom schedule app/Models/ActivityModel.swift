//
//  ActivityModel.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 30/9/24.
//

import Foundation
class ActivityModel : Hashable{
    //The id is a string format of the date of the activity
    var id : String
    var time: TimeModel
    var title : String
    var weather : String = "Sunny"
    
    init(id: String, title: String, time: TimeModel) {
        self.id = id
        self.title = title
        self.time = time
    }
    
    //Functions to make hashable work.
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
        hasher.combine(title)
        hasher.combine(id)
        hasher.combine(weather)
        
    }
    
    static func ==(lhs: ActivityModel, rhs: ActivityModel) -> Bool {
        return lhs.id == rhs.title && lhs.time == rhs.time && lhs.id == rhs.id && lhs.weather == rhs.weather
    }
    
}
