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

import UIKit
/**
 画面遷移を管理
 */
public final class Router {
    public static let shared: Router = .init()
    private init() {}

    private var window: UIWindow!

    // MARK: static method

    /**
     起動直後の画面を表示する
     - parameter window: UIWindow
     */
    public func showRoot(window: UIWindow?) {
        let vc = SlideViewController.make()
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()

        self.window = window
    }
}
