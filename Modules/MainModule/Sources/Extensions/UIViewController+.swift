//
//  UIViewController+.swift
//  
//
//  Created by sakiyamaK on 2023/03/08.
//

import UIKit

public extension UIViewController {
    func show(next: UIViewController, animated: Bool, isPresent: Bool = false, completion: (() -> Void)? = nil) {
        if let nav = self.navigationController, !isPresent {
            nav.pushViewController(next, animated: animated)
            completion?()
        } else {
            self.present(next, animated: animated, completion: completion)
        }
    }
    
    func popOrDismiss(animated: Bool, completion: ((UINavigationController?) -> Void)? = nil) {
        guard let nav = self.navigationController else {
            self.dismiss(animated: animated, completion: { completion?(nil) })
            return
        }
        nav.popViewController(animated: animated)
        completion?(nav)
    }
    
    // 強制タッチエンド
    func compulsionTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponder()
        self.view.touchesEnded(touches, with: event)
    }
    // MARK: - containerview
    func addContainer(viewController: UIViewController, containerView: UIView) {
        self.addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        viewController.didMove(toParent: self)
    }
    
    func removeContainer(viewController: UIViewController) {
        viewController.willMove(toParent: self)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func removeAllContainer() {
        self.children.forEach {
            self.removeContainer(viewController: $0)
        }
    }
    var withNavigationController: UINavigationController {
        UINavigationController(rootViewController: self)
    }
    
}

