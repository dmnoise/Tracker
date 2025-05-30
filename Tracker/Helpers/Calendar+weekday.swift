//
//  Calendar+weekday.swift
//  Tracker
//
//  Created by Dmitriy Noise on 27.05.2025.
//

import Foundation

extension Calendar {
    func weekday(from date: Date) -> Weekday {
        let weekdayNumber = self.component(.weekday, from: date)
        return Weekday(calendarWeekday: weekdayNumber)
    }
}
