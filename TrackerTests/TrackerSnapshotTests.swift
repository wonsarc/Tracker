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

    func testLightCreateTrackerViewController() {
        let сreateTrackerVC = CreateTrackerViewController()

        assertSnapshot(
            of: сreateTrackerVC,
            as: .image(
                on: .init(traits: UITraitCollection(userInterfaceStyle: .light))
            )
        )
    }

    func testDarkCreateTrackerViewController() {
        let сreateTrackerVC = CreateTrackerViewController()

        assertSnapshot(of: сreateTrackerVC, as: .image(on: .init(traits: UITraitCollection(userInterfaceStyle: .dark))))
    }

    func testLightTrackerViewController() {
        let trackerVC = TrackersViewController()

        assertSnapshot(of: trackerVC, as: .image(on: .init(traits: UITraitCollection(userInterfaceStyle: .light))))
    }

    func testDarkTrackerViewController() {
        let trackerVC = TrackersViewController()

        assertSnapshot(of: trackerVC, as: .image(on: .init(traits: UITraitCollection(userInterfaceStyle: .dark))))
    }
}
