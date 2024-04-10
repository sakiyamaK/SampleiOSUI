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
                            bar: UIView.spacer().height(0.5).backgroundColor(.black)
                        )
                    )
        let scrollNavgationTabBarPageViewController = ScrollNavigationTabBarPageViewController(
            navigationTabView: navigationTabView,
            viewControllers: [
                ScrollNavigationBarPagingViewController().apply {[weak self] in
                    guard let self else { return }
                    DLog(self.view.safeAreaInsets.top)
                    $0.setupScrollView = { scrollView -> Void in
                        DLog(navigationTabView.frame.height)
                        scrollView.contentInset = .init(top: navigationTabView.frame.height, left: 0, bottom: 0, right: 0)
                    }
                    
                    $0.setScrollHideViewActions = { scrollView in
                        [
                            ScrollHideViewAction(
                                scrollAlgorithm: ScrollHideViewAction.scrollNavigationBar,
                                scrollView: scrollView,
                                moveView: self.navigationController?.navigationBar
                            ),
                            ScrollHideViewAction(
                                scrollAlgorithm: ScrollHideViewAction.scroll,
                                scrollView: scrollView,
                                moveView: navigationTabView
                            )
                        ]
                    }

                    $0.title = "left"
                },
                ScrollNavigationBarPagingViewController().apply {[weak self] in
                    guard let self else { return }
                    $0.setupScrollView = { scrollView -> Void in
                        DLog(navigationTabView.frame.height)
                        scrollView.contentInset = .init(top: navigationTabView.frame.height, left: 0, bottom: 0, right: 0)
                    }
                    $0.setScrollHideViewActions = { scrollView in
                        [
                            ScrollHideViewAction(
                                scrollAlgorithm: ScrollHideViewAction.scrollNavigationBar,
                                scrollView: scrollView,
                                moveView: self.navigationController?.navigationBar
                            ),
                            ScrollHideViewAction(
                                scrollAlgorithm: ScrollHideViewAction.scroll,
                                scrollView: scrollView,
                                moveView: navigationTabView
                            )
                        ]
                    }

                    $0.title = "right"
                }
            ]
        )
        
        self.addContainer(
            viewController: scrollNavgationTabBarPageViewController,
            containerView: self.view
        )
    }
}
