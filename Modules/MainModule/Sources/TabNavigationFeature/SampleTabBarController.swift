//
//  SampleTabController.swift
//  
//
//  Created by sakiyamaK on 2023/07/22.
//

import UIKit
import DeclarativeUIKit
import Extensions

public class SampleTabBarController: UITabBarController {
    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        
        setupLayout()
    }
    
    
    @objc func setupLayout() {
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            PopoverTestUIViewController()
                .tabBarItem(UITabBarItem(title: "tab1", image: .none, tag: 0)),
            
            UIViewController().applyView({
                $0.backgroundColor(.white)
            }).declarative({
                UILabel("tab2")
                    .textColor(.systemBlue)
                    .center()
            })
            .tabBarItem(UITabBarItem(title: "tab1", image: .none, tag: 0)),
            
            UIViewController().applyView({
                $0.backgroundColor(.white)
            }).declarative({
                UILabel("tab3")
                    .textColor(.systemBlue)
                    .center()
            })
            .tabBarItem(UITabBarItem(title: "tab1", image: .none, tag: 0)),
        ]
        
        declarative(reset: false) {
            UIButton("fabfab")
                .titleColor(.systemBlue)
//                .addAction(.touchUpInside) {_ in
//                    print("tap")
//                }
                .right()
                .bottom()
                .offset(.init(x: -30, y: -30))
            //                .apply { fabContainerView in
            //                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            //                        self?.view.bringSubviewToFront(fabContainerView)
            //                    }
            //                }
        }
        
    }
}

public class PopoverTestUIViewController: UIViewController {
    
    public override func loadView() {
        super.loadView()
        
        self.applyView({
            $0.backgroundColor(.white)
        })
        .declarative({
            UIButton("tab1")
                .titleColor(.systemBlue)
//                .addAction(.touchUpInside) { action in
//                    let button: UIButton = action.sender as! UIButton
//                    print("tap tab1")
//                    UIViewController()
//                        .applyView({
//                            $0.isUserInteractionEnabled(true)
//                                .addGestureRecognizer {
//                                    UITapGestureRecognizer(target: self) {[weak self] _ in
//                                        guard let vc = self else { return }
//                                        vc.presentedViewController?.dismiss(animated: true)
//                                    }
//                                }
//                        })
//                        .declarative({
//                            UILabel("popover")
//                                .center()
//                        })
//                        .modalPresentationStyle(.popover)
//                        .applyPopoverPresentationController({[weak self] popoverController in
//                            guard let self else { return }
//                            popoverController?.sourceView(button).delegate(self)
//                        })
//                        .present(from: self, animated: true)
//                }
                .center()
        })
    }
}

extension PopoverTestUIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

// UIView拡張を使ってUIViewControllerを取得するメソッド
extension UIResponder {
    func next<T>(of type: T.Type) -> T? {
        guard let responder = self.next else {
            return nil
        }
        
        if let target = responder as? T {
            return target
        } else {
            return responder.next(of: type)
        }
    }
}
