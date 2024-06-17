//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Artem Krasnov on 17.06.2024.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {

    // MARK: - Public Properties

    // MARK: - Private Properties

    // MARK: - Initializers

    // MARK: - Overrides Methods

    // MARK: - Public Methods

    func eventOpenScreen(_ screen: String) {
        let params = Event(
            eventType: .open,
            screen: screen,
            itemType: nil
        ).createParams()

        sendEvent(for: params)
    }

    func eventCloseScreen(_ screen: String) {
        let params = Event(
            eventType: .close,
            screen: screen,
            itemType: nil
        ).createParams()

        sendEvent(for: params)
    }

    func eventClick(on screen: String, for type: ItemType) {
        let params = Event(
            eventType: .click,
            screen: screen,
            itemType: type
        ).createParams()

        sendEvent(for: params)
    }

    // MARK: - Private Methods

    private func sendEvent(for params: [AnyHashable: Any]) {
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

// MARK: EventType

enum EventType {
    case open
    case close
    case click
}

// MARK: ItemType

enum ItemType {
    case addTrack
    case track
    case filter
    case edit
    case delete
}

// MARK: Event

struct Event {
    let eventType: EventType
    let screen: String
    let itemType: ItemType?

    func createParams() -> [AnyHashable: Any] {
        var eventDict: [AnyHashable: Any] = [
            "eventType": "\(eventType)",
            "screen": screen
        ]

        if let itemType = itemType {
            eventDict["itemType"] = "\(itemType)"
        }

        return eventDict
    }
}
