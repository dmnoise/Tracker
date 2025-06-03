//
//  Weekday.swift
//  Tracker
//
//  Created by Dmitriy Noise on 20.05.2025.
//

enum Weekday: Int, CaseIterable, Hashable {
    case monday = 0
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    init(calendarWeekday: Int) {
        let adjustedValue = (calendarWeekday + 5) % 7
        self = Weekday(rawValue: adjustedValue) ?? .monday
    }
    
    var name: String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
}
