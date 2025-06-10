//
//  Tracker.swift
//  Tracker
//
//  Created by Dmitriy Noise on 20.05.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: Character
    let schedule: Set<Weekday>
    
    init(name: String, color: UIColor, emoji: Character, schedule: Set<Weekday>) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}
