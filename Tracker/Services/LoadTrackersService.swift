//
//  LoadTrackersService.swift
//  Tracker
//
//  Created by Dmitriy Noise on 29.05.2025.
//

final class LoadTrackersService {
    
    static let shared = LoadTrackersService()
    
    private init() { }
    
    func loadData() -> [TrackerCategory] {

        var trackers = [[Tracker]]()
        var categories = [TrackerCategory]()
        
        trackers.append([
            Tracker(
                name: "Поесть бургер, большой такой",
                color: .cAnotherBlue,
                emoji: "🍔",
                schedule: [.monday, .friday, .tuesday]
            ),
            Tracker(
                name: "Улыбнуться новому дню",
                color: .cLightRed,
                emoji: "🙂",
                schedule: [.monday, .friday]
            ),
            Tracker(
                name: "Сделать домашку",
                color: .cPink,
                emoji: "🤔",
                schedule: [.monday, .friday]
            )
        ])
        
        trackers.append([
            Tracker(
                name: "Понюхать цветочек",
                color: .cAnotherGreen,
                emoji: "🌺",
                schedule: [.monday, .tuesday]
            ),
            Tracker(
                name: "Лежать довольным на пляже",
                color: .cBeige,
                emoji: "🏝️",
                schedule: [.monday]
            ),
            Tracker(
                name: "До отвала есть мороженное",
                color: .cOrange,
                emoji: "🥶",
                schedule: [.monday]
            ),Tracker(
                name: "Много играть на басухе",
                color: .cLilac,
                emoji: "🎸",
                schedule: [.monday, .tuesday]
            ),
            Tracker(
                name: "Погладить собачку",
                color: .cLightGreen,
                emoji: "🐶",
                schedule: [.monday]
            ),
            Tracker(
                name: "Быть ангелочком",
                color: .cLightBlue,
                emoji: "😇",
                schedule: [.monday]
            )
        ])
        
        for (key, tracker) in trackers.enumerated() {
            categories.append(TrackerCategory(title: "Категория №\(key)", trackers: tracker))
        }
        
        return categories
    }
}
