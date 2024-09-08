//
//  ScrollNavigationBarViewController.swift
//
//
//  Created by sakiyamaK on 2024/04/08.
//

import UIKit
import DeclarativeUIKit
import Extensions

public class ScrollNavigationBarViewController: UIViewController {
    deinit {
        DLog()
    }
    public override func viewDidLoad() {
        
        let navigationTabView = NavigationTabView(
                        parameter: .init(
                            buttons: [
                                UIButton(
                                    configuration: .plain().title(
                                        "tap 0"
                                    )
                                ),
                                UIButton(
                                    configuration: .plain().title(
                                        "tap 1"
                                    )
                                )
                            ],
                            bar: UIView.spacer().height(1.0).backgroundColor(.black)
                        )
                    )
        let scrollNavgationTabBarPageViewController = ScrollNavigationTabBarPageViewController(
            navigationTabView: navigationTabView,
            setViewControllers: {[weak self] navigationTabContainerView in
                guard let self else { return [] }
                return [
                    ScrollNavigationBarPagingViewController().apply {[weak self] in
                        guard let self else { return }
                        $0.setupScrollView = { scrollView in
                            scrollView.contentInset = .init(top: navigationTabContainerView.frame.height, left: 0, bottom: 0, right: 0)
                        }
                        
                        $0.setScrollHideViewActions = {[weak self] scrollView in
                            guard let self else { return [] }
                            return [
                                ScrollHideViewAction(
                                    scrollView: scrollView,
                                    moveView: self.navigationController?.navigationBar
                                ),
                                ScrollHideViewAction(
                                    scrollView: scrollView,
                                    moveView: navigationTabContainerView
                                )
                            ]
                        }

                        $0.title = "left"
                    },
                    ScrollNavigationBarPagingViewController().apply {[weak self] in
                        guard let self else { return }
                        $0.setupScrollView = { scrollView in
                            scrollView.contentInset = .init(top: navigationTabContainerView.frame.height, left: 0, bottom: 0, right: 0)
                        }
                        $0.setScrollHideViewActions = {[weak self] scrollView in
                            guard let self else { return [] }
                            return [
                                ScrollHideViewAction(
                                    scrollView: scrollView,
                                    moveView: self.navigationController?.navigationBar
                                ),
                                ScrollHideViewAction(
                                    scrollView: scrollView,
                                    moveView: navigationTabContainerView
                                )
                            ]
                        }

                        $0.title = "right"
                    }
                ]
            }
        )
        
        self.addContainer(
            viewController: scrollNavgationTabBarPageViewController,
            containerView: self.view
        )
    }
}

#Preview {
    ScrollNavigationBarViewController()
}
