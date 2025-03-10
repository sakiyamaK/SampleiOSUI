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
import ArchitectureFeature
import UIKit
import DeclarativeUIKit
import IQKeyboardManagerSwift
import ButtonsFeature
import SwiftData
import SampleSwiftDataFeature

private enum ViewType: String, CaseIterable {
    case SwiftData
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
    case ArchitectureFeature

    var viewController: UIViewController {
        switch self {
        case .SwiftData:
            SampleSwiftDataViewController()
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
            UIViewController()
//            SampleViewController()
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
        case .ArchitectureFeature:
            UserTab2RouterImpl.assembleModules()
        }
    }
}

public final class RootViewController: UIViewController {
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

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
                            .addAction(.touchUpInside, handler: {[weak self] _ in
                                Task { @MainActor in
                                    let vc = viewType.viewController
                                    if vc is UITabBarController {
                                        self?.navigationController?.setNavigationBarHidden(true, animated: true)
                                    }
                                    if let vc = vc as? SampleSwiftDataViewController {
                                        print(#line)
                                        vc.set(
                                            viewModel: SampleSwiftDataViewModel()
                                        )
                                    }
//                                    LeakChecker.shared.append(instance: vc)
                                    self?.navigationController?.pushViewController(vc, animated: true)
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

        window.rootViewController = RootViewController().withNavigationController

        window.makeKeyAndVisible()
        self.window = window
    }
}
