// このファイルで各モジュールを外部に公開する

@_exported import CoreLibraries
@_exported import Extensions
@_exported import Components
@_exported import SampleFeature
@_exported import HeroFeature
@_exported import ChartFeature
//@_exported import ZoomImageFeature
//@_exported import SampleAffineFeature
//@_exported import CollectionViewFeature
//@_exported import SampleTextViewFeature
//@_exported import TabNavigaitonFeature
//@_exported import ScrollNavigationBarFeature
//@_exported import ComposeForiOSNative
//@_exported import SwiftUIHostingFeature

import UIKit
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
    
    case CustomNavigationBar
    case Hero
    case ScrollNavigationBar
    case Sample
    case Chart
    case CollectionView
    case SampleAffine
    case SampleTable
    case SampleTextView
    case SwiftUIHosting
    case TabNavigation
    case ZoomImage
    case ComposeForiOSNative

    var viewController: UIViewController {
        switch self {
        case .Hero:
            SampleHeroViewContreoller()
        case .Chart:
            ChartsViewController()
        case .Sample:
            SampleViewController()
//        case .CustomNavigationBar:
//            CustomNavigationPageViewController()
//        case .ComposeForiOSNative:
//            SampleComposeForiOSNativeViewController()
//        case .CollectionView:
//            RootCollectionViewController()
//        case .SampleAffine:
//            SampleAffineViewController()
//        case .SampleTable:
//            SampleTableViewController()
//        case .SampleTextView:
//            SampleTextViewController()
//        case .ScrollNavigationBar:
//            ScrollNavigationBarViewController()
//        case .SwiftUIHosting:
//            SwiftUIHosting01ViewController()
//        case .TabNavigation:
//            SampleTabBarController()
//        case .ZoomImage:
//            ZoomImageViewController.make()
        default:
            UIViewController()
        }
    }
    
    func button(from: UIViewController) -> UIButton {
        UIButton(self.rawValue)
            .configuration(
                UIButton.Configuration.filled()
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

struct User {
    let id: Int
    var name: String
}

final class CustomView: UIView {
    func setup(user: User) {
        // 名前を表示させたりアイコンを読み込んだり
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
    RootViewController()
    
//    App.shared.showRoot(
//        window: UIWindow(
//            frame: .init(
//                origin: .zero,
//                size: .init(width: 400, height: 800)
//            )
//        )
//    )
}
