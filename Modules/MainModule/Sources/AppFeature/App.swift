// このファイルで各モジュールを外部に公開する

@_exported import Extensions
@_exported import Components
@_exported import ChartFeature
@_exported import SwiftUIHostingFeature
@_exported import SampleTableFeature
@_exported import SampleFeature
@_exported import ZoomImageFeature
@_exported import SampleAffineFeature
@_exported import CollectionViewFeature
@_exported import SampleTextViewFeature
@_exported import TabNavigationFeature
@_exported import ScrollNavigationBarFeature

import IQKeyboardManagerSwift
import UIKit
import DeclarativeUIKit
import Extensions

private enum ViewType: String, CaseIterable {
    
    case Chart
    case CollectionView
    case SampleAffine
    case Sample
    case SampleTable
    case SampleTextView
    case ScrollNavigationBar
    case SwiftUIHosting
    case TabNavigation
    case ZoomImage

    var viewController: UIViewController {
        switch self {
        case .Chart:
            ChartsViewController()
        case .CollectionView:
            RootCollectionViewController()
        case .SampleAffine:
            SampleAffineViewController()
        case .Sample:
            SampleViewController()
        case .SampleTable:
            SampleTableViewController()
        case .SampleTextView:
            SampleTextViewController()
        case .ScrollNavigationBar:
            ScrollNavigationBarController()
        case .SwiftUIHosting:
            SwiftUIHosting01ViewController()
        case .TabNavigation:
            SampleTabBarController()
        case .ZoomImage:
            ZoomImageViewController.make()
        }
    }
    
    func button(from: UIViewController) -> UIButton {
        UIButton(self.rawValue)
            .apply({
                $0.configuration = .filled()
            })
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

        self.applyView {
            $0.backgroundColor(.white)
        }.applyNavigationItem {
            $0.title = "Root"
        }
        .declarative {
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

//#Preview {
//    RootViewController()
//}
