import IQKeyboardManagerSwift
import UIKit
import AppFeature

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        App.shared.showRoot(window: UIWindow(frame: UIScreen.main.bounds))
        return true
    }
}
