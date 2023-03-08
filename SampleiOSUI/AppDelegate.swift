import IQKeyboardManagerSwift
import UIKit
import AppFeature

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //        #if DEBUG
        //        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        //        #endif

        //        let navigationBarAppearanceDefault = UINavigationBarAppearance.default
        //        let navigationBarAppearance = UINavigationBar.appearance()
        //        navigationBarAppearance.standardAppearance = navigationBarAppearanceDefault
        //        navigationBarAppearance.compactAppearance = navigationBarAppearanceDefault
        //        navigationBarAppearance.scrollEdgeAppearance = navigationBarAppearanceDefault

        Router.shared.showRoot(window: UIWindow(frame: UIScreen.main.bounds))
        return true
    }
}
