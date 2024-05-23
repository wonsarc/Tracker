//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 09.03.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {

    // MARK: - Private Properties

    private lazy var pages: [UIViewController] = {

        let first = UIViewController()
        if let background = UIImage(named: "FirstBackground") {
            let imageView = UIImageView()
            imageView.image = background
            imageView.translatesAutoresizingMaskIntoConstraints = false
            first.view.addSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: first.view.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: first.view.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: first.view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: first.view.trailingAnchor)
            ])
        }

        let second = UIViewController()
        if let background = UIImage(named: "SecondBackground") {
            let imageView = UIImageView()
            imageView.image = background
            imageView.translatesAutoresizingMaskIntoConstraints = false
            second.view.addSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: second.view.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: second.view.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: second.view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: second.view.trailingAnchor)
            ])
        }

        return [first, second]
    }()

    private lazy var pageControl: UIPageControl = {

        let pageControl = UIPageControl()

        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray

        pageControl.accessibilityIdentifier = "pageControl"

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    lazy var confirmButton: UIButton = {

        let confirmButton = UIButton(type: .system)

        confirmButton.backgroundColor = .black
        confirmButton.setTitle(
            NSLocalizedString(
                "onboardingVC.confirmButton.title",
                comment: ""
            ),
            for: .normal
        )
        confirmButton.titleLabel?.font = .systemFont(ofSize: 16)
        confirmButton.tintColor = .white
        confirmButton.layer.cornerRadius = 16

        confirmButton.addTarget(
            self,
            action: #selector(confirmButtonTapped),
            for: .allTouchEvents
        )

        confirmButton.accessibilityIdentifier = "confirmButton"

        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        return confirmButton

    }()

    private lazy var textLabel: UILabel = {

        let textLabel = UILabel()

        textLabel.text = NSLocalizedString("onboardingVC.firstScreen.textLabel.text", comment: "")
        textLabel.numberOfLines = 2
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.textAlignment = .center
        textLabel.textColor = .black
        textLabel.font = .boldSystemFont(ofSize: 32)

        textLabel.accessibilityIdentifier = "textLabel"

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()

    // MARK: - Initializers

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Overrides Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }

        setupConfirmButton()
        setupPageControl()
        setupTextLabel()
    }

    // MARK: - Private Methods

    private func setupTextLabel() {
        view.addSubview(textLabel)

        textLabel.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -130).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }

    private func setupPageControl() {
        view.addSubview(pageControl)

        pageControl.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -24).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func setupConfirmButton() {
        view.addSubview(confirmButton)

        confirmButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -50
        ).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 335).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    private func setLabelText(for page: Int) {
        textLabel.text = page == 0 ?
        NSLocalizedString("onboardingVC.firstScreen.textLabel.text", comment: "") :
        NSLocalizedString("onboardingVC.secondScreen.textLabel.text", comment: "")
    }

    @objc private func confirmButtonTapped() {
        AppSettings.isFirstOpen = false
        present(SplashViewController(), animated: false)
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {

        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return pages[pages.count - 1]
        }

        return pages[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else {
            return pages[0]
        }

        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {

        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
            setLabelText(for: currentIndex)
        }
    }
}
