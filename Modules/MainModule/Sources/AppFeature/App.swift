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

public class App {
    public static let shared: App = .init()
    private init() {}

    private var window: UIWindow?
    
    public func showRoot(window: UIWindow) {

        //        let navigationBarAppearanceDefault = UINavigationBarAppearance.default
        //        let navigationBarAppearance = UINavigationBar.appearance()
        //        navigationBarAppearance.standardAppearance = navigationBarAppearanceDefault
        //        navigationBarAppearance.compactAppearance = navigationBarAppearanceDefault
        //        navigationBarAppearance.scrollEdgeAppearance = navigationBarAppearanceDefault

        let vc = SampleAffineViewController()
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
        self.window = window
    }
}
