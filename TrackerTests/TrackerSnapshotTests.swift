//
//  TrackerSnapshotTests.swift
//  TrackerTests
//
//  Created by Artem Krasnov on 25.05.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {

    func testCreateTrackerViewController() {
        let сreateTrackerVC = CreateTrackerViewController()

        assertSnapshot(of: сreateTrackerVC, as: .image)
    }

    func testTrackerViewController() {
        let trackerVC = TrackersViewController()

        assertSnapshot(of: trackerVC, as: .image)
    }
}
