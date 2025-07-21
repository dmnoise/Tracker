//
//  Array+filteredByCompletedState.swift
//  Tracker
//
//  Created by Dmitriy Noise on 19.07.2025.
//

import Foundation

extension Array where Element == TrackerCategory {
    func filteredByCompletionState(
        completedTrackers: Set<TrackerRecord>,
        selectedDate: Date,
        isFinished: Bool
    ) -> [TrackerCategory] {
        let weekday = Calendar.current.weekday(from: selectedDate)
        
        return self.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                if tracker.schedule.isEmpty {
                    if isFinished {
                        let hasRecord = completedTrackers.contains {
                            $0.trackerID == tracker.id &&
                            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
                        }
                        return hasRecord
                    } else {
                        let wasEverCompleted = completedTrackers.contains { $0.trackerID == tracker.id }
                        return !wasEverCompleted
                    }
                }
                
                guard tracker.schedule.contains(weekday) else { return false }
                
                let isCompletedToday = completedTrackers.contains {
                    $0.trackerID == tracker.id &&
                    Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
                }
                return isFinished ? isCompletedToday : !isCompletedToday
            }
            
            guard !trackers.isEmpty else { return nil }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
    }
}

