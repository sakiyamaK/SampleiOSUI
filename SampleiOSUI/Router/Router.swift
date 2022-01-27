//
//  Router.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2021/01/16.
//

import UIKit

/**
 画面遷移を管理
 */
final class Router {
    static let shared: Router = .init()
    private init() {}

    private var window: UIWindow!

    // MARK: static method

    /**
     起動直後の画面を表示する
     - parameter window: UIWindow
     */
    func showRoot(window: UIWindow?) {
        //        let vc = StackTableViewViewController.makeFromStoryBoard()
        //        let vc = R.storyboard.slide.slideViewController()!
        //        let vc = R.storyboard.sampleTable.sampleTableViewController()!
        //        let vc = R.storyboard.zoomImage.zoomImageViewController()!
        //        let rootVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = UINavigationController(
            rootViewController: SimpleViewController()
        )
        window?.makeKeyAndVisible()
        self.window = window
    }
}
