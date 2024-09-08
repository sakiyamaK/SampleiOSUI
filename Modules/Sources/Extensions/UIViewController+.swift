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
    func addContainer(viewController: UIViewController, containerView: UIView, isSafeArea: Bool = false) {
        self.addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        let activates = if isSafeArea {
            [
                viewController.view.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
                viewController.view.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
                viewController.view.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
                viewController.view.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor)
            ]
        } else {
            [
                viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ]
        }

        NSLayoutConstraint.activate(activates)
        viewController.didMove(toParent: self)
    }

    func addContainer(viewController: UIViewController, containerView: UIView, completion: @escaping ((UIViewController) -> Void)) {
        self.addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        completion(viewController)
    }

    func addContainer(viewController: UIViewController, completion: @escaping ((UIViewController) -> Void)) {
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        completion(viewController)
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
    
    func withNavigationController(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) -> UINavigationController {
        let nav = UINavigationController(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        nav.viewControllers = [self]
        return nav
    }

}

public extension UIViewController {
    static func storyboard(name: String? = nil, bundle: Bundle? = nil) -> UIStoryboard {
        UIStoryboard(name: name ?? className, bundle: bundle)
    }
    static func makeFromStroryboard(name: String? = nil, bundle: Bundle? = nil) -> Self? {
        storyboard(name: name, bundle: bundle).instantiateInitialViewController()
    }

}
