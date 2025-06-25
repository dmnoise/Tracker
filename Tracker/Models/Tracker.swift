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

extension Tracker {
    init?(from coreData: TrackerCoreData) {
        guard
            let id = coreData.id,
            let name = coreData.name,
            let emojiString = coreData.emoji,
            let emoji = emojiString.first,
            let colorHex = coreData.colorHex
        else {
            return nil
        }

        let color = UIColorMarshalling().color(from: colorHex)
        let schedule = Set<Weekday>.fromJSONString(coreData.schedule)

        self.init(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
    }

    init(id: UUID, name: String, color: UIColor, emoji: Character, schedule: Set<Weekday>) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}

