//
//  File.swift
//  
//
//  Created by sakiyamaK on 2023/04/09.
//

import UIKit
import DeclarativeUIKit
import Hero
import Extensions
import SwiftyAttributes

private enum ViewType: String, CaseIterable {
    
    case Sample
    case VerticalText

    var viewController: UIViewController {
        switch self {
        case .Sample:
            return SampleTextViewController()
        case .VerticalText:
            return VerticalTextViewController()
        }
    }
    
    func button(from: UIViewController) -> UIButton {
        UIButton(
            configuration: .filled()
                .title(self.rawValue)
                .titlePadding(10)
                .baseBackgroundColor(.systemBlue)
                .cornerStyle(.capsule)
        )
        .addAction(.touchUpInside, handler: { _ in
            from.navigationController?.pushViewController(self.viewController, animated: true)
        })
    }
}


public final class RootTextViewController: UIViewController {
        
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

#Preview {
    RootTextViewController()
}
