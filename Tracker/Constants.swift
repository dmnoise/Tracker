//
//  Constants.swift
//  Tracker
//
//  Created by Dmitriy Noise on 04.06.2025.
//

enum Constants {
    
    static let maxNameLength = 38
    
    enum TrackerType {
        case habbit
        case event
        case edit
    }
    
    enum FilterType: String, Codable {
        case all
        case today
        case finished
        case unfinished
    }
}
