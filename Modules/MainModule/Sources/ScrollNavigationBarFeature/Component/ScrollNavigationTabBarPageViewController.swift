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

    private weak var navigationTabView: (UIView & ScrollNavigationTabBarPageTabViewProtocol)!
    private(set) var settingViewControllers: [UIViewController & ScrollNavigationTabBarPagingViewControllerProtocol] = []

    private func currentIndex(from: UIViewController) -> Int? {
        settingViewControllers.firstIndex(where: { $0 === from })
    }
                                          
    private func tapNavigationTabButton(index: Int) {
        guard 
            let nextViewController = settingViewControllers[safe: index],
            let currentVC = viewControllers?.first,
            let currentIndex = currentIndex(from: currentVC)
        else {
            return
        }
        let direction: UIPageViewController.NavigationDirection = currentIndex < index ? .forward : .reverse
        setViewControllers([nextViewController], direction: direction, animated: true)
        navigationTabView.selectTab(index: index)
    }
    
    init(
        navigationTabView: (UIView & ScrollNavigationTabBarPageTabViewProtocol),
        viewControllers: [UIViewController & ScrollNavigationTabBarPagingViewControllerProtocol]
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.settingViewControllers = viewControllers
        self.navigationTabView = navigationTabView
        self.navigationTabView = navigationTabView
        navigationTabView.tap = tapNavigationTabButton(index:)
        self.settingViewControllers = viewControllers
        setViewControllers([viewControllers.first!], direction: .forward, animated: false, completion: nil)
                
        self.view.addSubview(navigationTabView)
        navigationTabView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationTabView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            navigationTabView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            navigationTabView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
        delegate = self
        dataSource = self
                                
        self.view.bringSubviewToFront(navigationTabView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScrollNavigationTabBarPageViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = currentIndex(from: viewControllers!.first!)!
        DLog("\(index), \(scrollView.contentOffset)")
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let index = currentIndex(from: viewControllers!.first!)!
        DLog("\(index), \(scrollView.contentOffset)")
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = currentIndex(from: viewControllers!.first!)!
        DLog("\(index), \(scrollView.contentOffset)")
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let index = currentIndex(from: viewControllers!.first!)!
        DLog("\(index), \(scrollView.contentOffset), \(decelerate)")
    }
}
extension ScrollNavigationTabBarPageViewController: UIPageViewControllerDelegate {
}

extension ScrollNavigationTabBarPageViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = currentIndex(from: viewController), index > 0 else { return nil }
        DLog(index)
        return settingViewControllers[index - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = currentIndex(from: viewController), index < settingViewControllers.count - 1 else { return nil }
        DLog(index)
        return settingViewControllers[index + 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let visibleViewController = pageViewController.viewControllers?.first, let index = currentIndex(
            from: visibleViewController
        ) else {
            return
        }

        DLog(index)
        navigationTabView.selectTab(index: index)
    }
}

