//
//  Set+shortNamesString.swift
//  Tracker
//
//  Created by Dmitriy Noise on 03.06.2025.
//

extension Set where Element == Weekday {
    var shortNamesString: String {
        self.sorted(by: { $0.rawValue < $1.rawValue })
            .map { $0.shortName }
            .joined(separator: ", ")
    }
}
