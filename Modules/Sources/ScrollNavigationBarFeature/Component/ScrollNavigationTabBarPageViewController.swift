//
//  ScrollNavigationBarParchementController.swift
//
//
//  Created by sakiyamaK on 2023/08/09.
//

import UIKit
import DeclarativeUIKit
import Extensions

// NavigationTabに設定するProtocol
public protocol ScrollNavigationTabBarPageTabViewProtocol: UIView {
    var navigationTabBarScrollView: UIScrollView! { get }
    var tap: ((Int) -> Void)? { get set }
    func selectTab(index: Int)
}

// ScrollViewをもつ各ページのViewControllerに設定するProtocol
public protocol ScrollNavigationTabBarPagingViewControllerProtocol: UIViewController {
    var setupScrollView: ((UIScrollView) -> Void)? { get set }
    var setScrollHideViewActions: ((UIScrollView) -> [ScrollHideViewAction])? { get set }
    // setScrollHideViewActionsの戻り値を保持するパラメータ
    var scrollHideViewActions: [ScrollHideViewAction] { get }
}

public class ScrollNavigationTabBarPageViewController: UIPageViewController {
    
    deinit {
        DLog()
    }

    private weak var navigationTabView: (UIView & ScrollNavigationTabBarPageTabViewProtocol)!
    private(set) var settingViewControllers: [UIViewController & ScrollNavigationTabBarPagingViewControllerProtocol] = []
    
    init(
        navigationTabView: (UIView & ScrollNavigationTabBarPageTabViewProtocol),
        setViewControllers: ((UIView) -> [UIViewController & ScrollNavigationTabBarPagingViewControllerProtocol])
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)

        self.navigationTabView = navigationTabView
        navigationTabView.tap = {[weak self] index in
            guard
                let self,
                let nextViewController = settingViewControllers[safe: index],
                let currentVC = viewControllers?.first,
                let currentIndex = currentIndex(from: currentVC)
            else {
                return
            }
            let direction: UIPageViewController.NavigationDirection = currentIndex < index ? .forward : .reverse
            self.setViewControllers([nextViewController], direction: direction, animated: true)
            navigationTabView.selectTab(index: index)
        }

        let containerView = UIView()
        self.view.addSubview(containerView.zStack({
            navigationTabView
        }))

        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
        
        delegate = self
        dataSource = self
        
        settingViewControllers = setViewControllers(containerView)
        self.setViewControllers([settingViewControllers.first!], direction: .forward, animated: false, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ScrollNavigationTabBarPageViewController {
    func currentIndex(from: UIViewController) -> Int? {
        settingViewControllers.firstIndex(where: { $0 === from })
    }
}

extension ScrollNavigationTabBarPageViewController: UIPageViewControllerDelegate {
}

extension ScrollNavigationTabBarPageViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = currentIndex(from: viewController), index > 0 else { return nil }
        return settingViewControllers[index - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = currentIndex(from: viewController), index < settingViewControllers.count - 1 else { return nil }
        return settingViewControllers[index + 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let visibleViewController = pageViewController.viewControllers?.first, let index = currentIndex(
            from: visibleViewController
        ) else {
            return
        }
        navigationTabView?.selectTab(index: index)
    }
}

