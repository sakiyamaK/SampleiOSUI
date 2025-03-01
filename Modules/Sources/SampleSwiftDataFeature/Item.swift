//
//  Item.swift
//  Modules
//
//  Created by sakiyamaK on 2025/02/10.
//

import SwiftData
import Foundation

@Model
public final class Item {
    var timestamp: Date
    public init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
