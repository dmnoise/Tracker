import Foundation

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
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        let weekdayIndex = (self.rawValue + 1) % 7
        return formatter.weekdaySymbols[weekdayIndex].capitalized
    }

    var shortName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        let weekdayIndex = (self.rawValue + 1) % 7
        return formatter.shortWeekdaySymbols[weekdayIndex].capitalized
    }
}
