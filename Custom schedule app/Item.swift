//
//  Item.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 19/9/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
