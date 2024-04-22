//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 09.03.2024.
//

import UIKit

final class OnboardingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        let label = UILabel()
        label.text = "Onbornding screen Comming soon.."
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 32)
        label.numberOfLines = 2
        label.textAlignment = .center

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
}
