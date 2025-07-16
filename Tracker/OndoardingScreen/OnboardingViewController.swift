//
//  OnboardingVIewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 08.07.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private let pages: [UIViewController] = [
        ScreenView(
            text: NSLocalizedString("firstScreen", comment: ""),
            image: UIImage(resource: .blueOnboardingBackground)
        ),
        ScreenView(
            text: NSLocalizedString("twoScreen", comment: ""),
            image: UIImage(resource: .redOnboardingBackground)
        )
    ]
    
    private lazy var pageControl: UIPageControl = {
        let obj = UIPageControl()
        obj.numberOfPages = pages.count
        obj.currentPage = 0
        
        obj.currentPageIndicatorTintColor = .yaBlack
        obj.pageIndicatorTintColor = .yaBlack.withAlphaComponent(0.3)
        
        return obj
    }()
    
    private lazy var nextButton: UIButton = {
        let obj = UIButton()
        let title = NSLocalizedString("technology", comment: "")
        obj.setTitle(title, for: .normal)
        obj.setTitleColor(.yaWhite, for: .normal)
        obj.backgroundColor = .yaBlack
        obj.layer.cornerRadius = 16
        
        return obj
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        setupUI()
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubviews(nextButton, pageControl)
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func didTapNextButton() {
        dismissToRoot()
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let perviousIndex = viewControllerIndex - 1
        
        guard perviousIndex >= 0 else {
            return pages.last
        }
        
        return pages[perviousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = pages.firstIndex(of: currentViewController)
        else { return }
        
        pageControl.currentPage = currentIndex
    }
}
