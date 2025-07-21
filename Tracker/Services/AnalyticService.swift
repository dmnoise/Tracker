//
//  AnalyticService.swift
//  Tracker
//
//  Created by Dmitriy Noise on 21.07.2025.
//

import AppMetricaCore

final class AnalyticService {
    static let shared = AnalyticService()
    
    private init() {
        if let configuration = AppMetricaConfiguration(apiKey: "d5036e35-624d-45a1-a52b-c8d40c64c999") {
            AppMetrica.activate(with: configuration)
        }
    }
    
    func reportEvent(_ name: String, params: [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: name, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
