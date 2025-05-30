//
//  Array+filteredByWeekday.swift
//  Tracker
//
//  Created by Dmitriy Noise on 29.05.2025.
//

import Foundation

extension Array where Element == TrackerCategory {
    func filteredByWeekday(_ weekday: Weekday) -> [TrackerCategory] {
        self.compactMap { category in
            let visibleTrackers = category.trackers.filter { $0.schedule.contains(weekday) }
            guard !visibleTrackers.isEmpty else { return nil }
            return TrackerCategory(title: category.title, trackers: visibleTrackers)
        }
    }
}
