//
//  Set+weekday.swift
//  Tracker
//
//  Created by Dmitriy Noise on 19.06.2025.
//

import Foundation

import Foundation

extension Set where Element == Weekday {
    func toJSONString() -> String? {
        let rawValues = self.map { $0.rawValue }
        if let data = try? JSONEncoder().encode(rawValues) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    static func fromJSONString(_ json: String?) -> Set<Weekday> {
        guard
            let jsonData = json?.data(using: .utf8),
            let rawValues = try? JSONDecoder().decode([Int].self, from: jsonData)
        else {
            return []
        }
        return Set(rawValues.compactMap { Weekday(rawValue: $0) })
    }
}
