//
//  UIViewController+Declarative.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2021/12/22.
//

import UIKit.UIViewController
import UIKit.UIStackView

extension UIViewController {
    func build(isSafeArea: Bool = true, isScrollEnabled: Bool = true, _ view: UIView) {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = isScrollEnabled
        self.view.edgesConstraints(scrollView, isSafeArea: isSafeArea)
        scrollView.addSubview(view)
        let height = view.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        height.priority = .init(rawValue: 1)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            view.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            scrollView.contentLayoutGuide.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            height
        ])
    }
}
