// このファイルで各モジュールを外部に公開する

import CoreLibraries
import Extensions
import Components
import Files
import HeroFeature
import SampleTextViewFeature
import ScrollNavigationBarFeature
import ZoomImageFeature
import ChartFeature
import CollectionViewFeature
import SampleAffineFeature
import SampleFeature
import TabNavigationFeature

import UIKit
import CoreAudioTypes
import DeclarativeUIKit
import IQKeyboardManagerSwift

// メモリーリークチェッククラス
@MainActor
class LeakChecker {
    static let shared: LeakChecker = .init()
    private init() {}
    
    private class WeakClassWrapper {
        weak var object: AnyObject?
        init(object: AnyObject?) {
            self.object = object
        }
    }

    private var weakClassInstances: [WeakClassWrapper] = []
    
    func append(instance: AnyObject) {
        weakClassInstances.append(WeakClassWrapper(object: instance))
    }
    
    func check() {
        let newWeakClassInstances = weakClassInstances.filter({ $0.object != nil })
        if newWeakClassInstances.isEmpty {
            print("リークなし")
        } else {
            print(newWeakClassInstances.count.description + "個のインスタンスがリークしてます")
        }
        
        weakClassInstances = newWeakClassInstances
    }
}

private enum ViewType: String, CaseIterable {
    
    case Hero
    case TabNavigation
    case CustomNavigationBar
    case ScrollNavigationBar
    case Sample
    case Chart
    case CollectionView
    case SampleAffine
    case SampleTextView
    case SwiftUIHosting
    case ZoomImage
    case ComposeForiOSNative

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
        default:
            UIViewController()
            //        case .SwiftUIHosting:
            //            RootSwiftUIHostingViewController()
//        case .ComposeForiOSNative:
//            SampleComposeForiOSNativeViewController()
        }
    }
    
    func button(from: UIViewController) -> UIButton {
        UIButton(
            configuration:
                UIButton.Configuration.filled()
                .title(self.rawValue)
                .baseBackgroundColor(.systemBlue)
                .cornerStyle(.capsule)
            )
            .addAction(.touchUpInside, handler: { _ in
                DispatchQueue.main.async {
                    let vc = self.viewController
                    LeakChecker.shared.append(instance: vc)
                    from.navigationController?.pushViewController(vc, animated: true)
                }
            })
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
                    ViewType.allCases.compactMap({ $0.button(from: self).height(40)
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
