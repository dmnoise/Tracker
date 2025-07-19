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
        self.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let isTrackerFinished = completedTrackers.contains {
                    $0.trackerID == tracker.id &&
                    Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
                }
                
                return isFinished ? isTrackerFinished : !isTrackerFinished
            }
            
            guard !trackers.isEmpty else { return nil }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
    }
}
