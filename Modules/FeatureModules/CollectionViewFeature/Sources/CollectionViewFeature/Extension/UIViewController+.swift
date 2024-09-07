//
//  UIViewController+.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2021/10/22.
//  Copyright © 2021 sakiyamaK. All rights reserved.
//

import UIKit

// MARK: - containerview

//extension UIViewController {
//    func addContainer(viewController: UIViewController, containerView: UIView) {
//        addChild(viewController)
//        containerView.addSubview(viewController.view)
//        viewController.didMove(toParent: self)
//    }
//
//    func removeContainer(viewController: UIViewController) {
//        viewController.willMove(toParent: self)
//        viewController.view.removeFromSuperview()
//        viewController.removeFromParent()
//    }
//}
//
//extension UIViewController {
//    var withNavigationController: UINavigationController {
//        UINavigationController(rootViewController: self)
//    }
//
//    func show(next: UIViewController, isPresent: Bool = false, animated: Bool = true, completion: (() -> Void)? = nil) {
//        if !isPresent, let nav = navigationController {
//            nav.pushViewController(next, animated: animated)
//        } else {
//            present(next, animated: animated) { completion?() }
//        }
//    }
//
//    func show(from: UIViewController, isPresent: Bool = false, animated: Bool = true, completion: (() -> Void)? = nil) {
//        if !isPresent, let nav = from.navigationController {
//            nav.pushViewController(self, animated: animated)
//        } else {
//            from.present(self, animated: animated) { completion?() }
//        }
//    }
//}
