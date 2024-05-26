//
//  Colors.swift
//  Tracker
//
//  Created by Artem Krasnov on 26.05.2024.
//

import UIKit

final class Colors {

    // MARK: - Public Properties

    static let shared = Colors()

    // MARK: - Private Properties

    let viewBackgroundColor = UIColor.systemBackground

    let buttonColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }

    let textColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor(red: 26.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        } else {
            return UIColor.white
        }
    }

    let dataPickerColor = UIColor(hex: 0xF0F0F0)

    let availableСolors: [UIColor] = [
         UIColor(hex: 0xFD4C49), UIColor(hex: 0xFF881E), UIColor(hex: 0x007BFA),
         UIColor(hex: 0x6E44FE), UIColor(hex: 0x33CF69), UIColor(hex: 0xE66DD4),
         UIColor(hex: 0xF9D4D4), UIColor(hex: 0x34A7FE), UIColor(hex: 0x46E69D),
         UIColor(hex: 0x35347C), UIColor(hex: 0xFF674D), UIColor(hex: 0xFF99CC),
         UIColor(hex: 0xF6C48B), UIColor(hex: 0x7994F5), UIColor(hex: 0x832CF1),
         UIColor(hex: 0xAD56DA), UIColor(hex: 0x8D72E6), UIColor(hex: 0x2FD058)
     ]

    // MARK: - Initializers

    private init() {}
}
