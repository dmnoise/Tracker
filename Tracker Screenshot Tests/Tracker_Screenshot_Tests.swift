//
//  Tracker_Screenshot_Tests.swift
//  Tracker Screenshot Tests
//
//  Created by Dmitriy Noise on 21.07.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class Tracker_Screenshot_Tests: XCTestCase {

    func testViewController() {
        let vc = TabBarController()
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }

}
