//
//  DaysValueTransformer.swift
//  Tracker
//
//  Created by Artem Krasnov on 09.05.2024.
//

import Foundation

@objc
final class DaysValueTransformer: ValueTransformer {

    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [WeekDaysModel] else { return nil }
        return try? JSONEncoder().encode(days)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([WeekDaysModel].self, from: data as Data)
    }

    static func register() {
        ValueTransformer.setValueTransformer(
            DaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        )
    }
}
