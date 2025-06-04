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
    
    
    func filteredHabitsAndEvents(on selectedDate: Date, recordTrackers: Set<TrackerRecord>) -> [TrackerCategory] {
        self.compactMap { category in
            let weekday = Calendar.current.weekday(from: selectedDate)
            
            let visibleTrackers = category.trackers.filter { tracker in
                if tracker.schedule.contains(weekday) {
                    return true
                } else if tracker.schedule.isEmpty {
                    let matchingRecords = recordTrackers.filter { $0.trackerID == tracker.id }
                    
                    if matchingRecords.isEmpty {
                        return true
                    }
                    
                    return matchingRecords.contains {
                        Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
                    }
                } else {
                    return false
                }
            }
            
            guard !visibleTrackers.isEmpty else { return nil }
            return TrackerCategory(title: category.title, trackers: visibleTrackers)
        }
    }
}
