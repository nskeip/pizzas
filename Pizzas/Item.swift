//
//  Item.swift
//  Pizzas
//
//  Created by Nikita Hismatov on 28.09.25.
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
