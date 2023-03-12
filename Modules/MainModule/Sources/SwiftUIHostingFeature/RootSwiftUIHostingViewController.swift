//
//  ViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/06.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

import UIKit
import DeclarativeUIKit
import Hero
import Extensions

private enum ViewType: String, CaseIterable {
    
    case SwiftUIHosting01
    case SwiftUIHosting02
    case SwiftUIHosting03

    var viewController: UIViewController {
        switch self {
        case .SwiftUIHosting01:
            return SwiftUIHosting01ViewController()
        case .SwiftUIHosting02:
            return SwiftUIHosting02ViewController()
        case .SwiftUIHosting03:
            return SwiftUIHosting03ViewController()
        }
    }
    
    func button(from: UIViewController) -> UIButton {
        UIButton(self.rawValue)
            .contentEdgeInsets(.init(top: 10, left: 10, bottom: 10, right: 10))
            .font(UIFont.systemFont(ofSize: 20))
            .backgroundColor(.systemBlue)
            .cornerRadius(10)
            .add(target: from, for: .touchUpInside) { _ in
                from.navigationController?.pushViewController(self.viewController, animated: true)
            }
    }
}


public final class RootSwiftUIHostingViewController: UIViewController {
        
    public override func loadView() {
        super.loadView()

        self.view.backgroundColor = .white
        self.navigationItem.title = "Root"
        
        self.declarative {
            UIScrollView.vertical {
                UIStackView.vertical {
                    ViewType.allCases.compactMap({ $0.button(from: self).height(40) })
                }
                .spacing(20)
                .distribution(.fillEqually)
                .alignment(.center)
                .center()
            }
            .showsScrollIndicator(false)
        }
    }
}

