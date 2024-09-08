// このファイルで各モジュールを外部に公開する

import Extensions
import Components
import Files
import Utils
import HeroFeature
import SampleTextViewFeature
import ScrollNavigationBarFeature
import ZoomImageFeature
import ChartFeature
import CollectionViewFeature
import SampleAffineFeature
import SampleFeature
import TabNavigationFeature
import SwiftUIHostingFeature
import ComposeForiOSNative

import UIKit
import DeclarativeUIKit
import IQKeyboardManagerSwift

private enum ViewType: String, CaseIterable {
    
    case Hero
    case SampleTextView
    case ScrollNavigationBar
    case CustomNavigationBar
    case SwiftUIHosting
    case TabNavigation
    case ZoomImage
    case Chart
    case CollectionView
    case ComposeForiOSNative
    case SampleAffine
    case Sample

    var viewController: UIViewController {
        switch self {
        case .Hero:
            SampleHeroViewContreoller()
        case .SampleTextView:
            SampleTextViewController()
        case .ScrollNavigationBar:
            ScrollNavigationBarViewController()
        case .ZoomImage:
            ZoomImageViewController.make()
        case .Chart:
            ChartsViewController()
        case .Sample:
            SampleViewController()
        case .CollectionView:
            RootCollectionViewController()
        case .SampleAffine:
            SampleAffineViewController()
        case .TabNavigation:
            SampleTabBarController()
        case .CustomNavigationBar:
            CustomNavigationPageViewController()
        case .SwiftUIHosting:
            RootSwiftUIHostingViewController()
        case .ComposeForiOSNative:
            SampleComposeForiOSNativeViewController()
//        default:
//            UIViewController()
        }
    }
}

public final class RootViewController: UIViewController {
            
    public override func loadView() {
        super.loadView()

        self.applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UIScrollView.vertical {
                UIStackView.vertical {
                    ViewType.allCases.compactMap({ viewType in
                        UIButton(
                            configuration:
                                UIButton.Configuration.filled()
                                .title(viewType.rawValue)
                                .baseBackgroundColor(.systemBlue)
                                .cornerStyle(.capsule)
                            )
                            .addAction(.touchUpInside, handler: { _ in
                                DispatchQueue.main.async {
                                    let vc = viewType.viewController
                                    LeakChecker.shared.append(instance: vc)
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
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

@MainActor
public class App {
    public static let shared: App = .init()
    private init() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableDebugging = true
    }

    private(set) var window: UIWindow?
    
    public func showRoot(window: UIWindow) {

//        let naviCon = UINavigationController(navigationBarClass: CustomNavigationBar.self, toolbarClass: nil)
//        naviCon.setViewControllers([CustomNavigationViewController()], animated: false)
        window.rootViewController = RootViewController().withNavigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}

#Preview {
    {
//        let naviCon = UINavigationController(navigationBarClass: CustomNavigationBar.self, toolbarClass: nil)
//        naviCon.setViewControllers([RootViewController()], animated: false)
//        return naviCon
        RootViewController().withNavigationController
    }()
}
