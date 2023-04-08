// このファイルで各モジュールを外部に公開する

@_exported import Extensions
@_exported import Components
@_exported import ChartFeature
@_exported import SwiftUIHostingFeature
@_exported import SampleTableFeature
@_exported import SampleFeature
@_exported import ZoomImageFeature
@_exported import StackTableFeature
@_exported import SampleAffineFeature
@_exported import SlideFeature
@_exported import CollectionViewFeature
@_exported import SampleTextViewFeature

import IQKeyboardManagerSwift
import UIKit
import DeclarativeUIKit
import Extensions

private enum ViewType: String, CaseIterable {
    
    case Sample
    case SampleTextView
    case RootSwiftUI
    case RootCollection
    
    var viewController: UIViewController {
        switch self {
        case .Sample:
            return SampleViewController()
        case .SampleTextView:
            return SampleTextViewController()
        case .RootSwiftUI:
            return RootSwiftUIHostingViewController()
        case .RootCollection:
            return RootCollectionViewController()
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


public final class RootViewController: UIViewController {
        
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


public class App {
    public static let shared: App = .init()
    private init() {
        IQKeyboardManager.shared.enable = true
    }

    private(set) var window: UIWindow?
    
    public func showRoot(window: UIWindow) {

        //        let navigationBarAppearanceDefault = UINavigationBarAppearance.default
        //        let navigationBarAppearance = UINavigationBar.appearance()
        //        navigationBarAppearance.standardAppearance = navigationBarAppearanceDefault
        //        navigationBarAppearance.compactAppearance = navigationBarAppearanceDefault
        //        navigationBarAppearance.scrollEdgeAppearance = navigationBarAppearanceDefault

        window.rootViewController = RootViewController().withNavigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
