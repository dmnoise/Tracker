//
//  UserDefaults+selectedFilter.swift
//  Tracker
//
//  Created by Dmitriy Noise on 19.07.2025.
//

import Foundation

extension UserDefaults {
    private static let selectedFilterKey = "selectedFilter"

    var selectedFilter: Constants.FilterType {
        get {
            guard
                let raw = self.string(forKey: Self.selectedFilterKey),
                let filter = Constants.FilterType(rawValue: raw)
            else { return .all }
            return filter
        }
        set {
            if newValue == .all {
                self.removeObject(forKey: Self.selectedFilterKey)
            } else {
                self.set(newValue.rawValue, forKey: Self.selectedFilterKey)
            }
        }
    }
    
    var isEnabledFilter: Bool {
        selectedFilter == .unfinished || selectedFilter == .finished
    }
}
