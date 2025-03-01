//
//  ViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/06.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

import UIKit
import DeclarativeUIKit
//import Hero
//import Extensions

private enum ViewType: String, CaseIterable {
    
    case SwiftUIHosting01
    case SwiftUIHosting02

    @MainActor
    var viewController: UIViewController {
        switch self {
        case .SwiftUIHosting01:
            SwiftUIHosting01View(viewModel: ViewModel01()).viewController
        case .SwiftUIHosting02:
            SwiftUIHosting02View(viewModel: ViewModel02(count: 10)).viewController
        }
    }
}


public final class RootSwiftUIHostingViewController: UIViewController {
        
    public override func loadView() {
        super.loadView()
        
        self.applyView { $0.backgroundColor(.white) }
            .applyNavigationItem { $0.title = "Root" }
            .declarative {
                UIScrollView.vertical {
                    UIStackView.vertical {
                        ViewType.allCases.compactMap({ viewType in
                            UIButton(
                                configuration: .bordered().title(
                                    viewType.rawValue
                                ).baseBackgroundColor(.systemBlue)
                                    .baseForegroundColor(.white)
                            )
                            .addAction(.touchUpInside, handler: { _ in
                                self.navigationController?.pushViewController(viewType.viewController, animated: true)
                            })
                        })
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
    RootSwiftUIHostingViewController().withNavigationController
}
