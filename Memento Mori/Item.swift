//
//  Item.swift
//  Memento Mori
//
//  Created by Shawn Price on 2024-09-11.
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
