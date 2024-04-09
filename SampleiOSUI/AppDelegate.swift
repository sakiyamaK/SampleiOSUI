import UIKit
import AppFeature

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationBarAppearanceDefault = UINavigationBarAppearance.default
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.standardAppearance = navigationBarAppearanceDefault
        navigationBarAppearance.compactAppearance = navigationBarAppearanceDefault
        navigationBarAppearance.scrollEdgeAppearance = navigationBarAppearanceDefault

        App.shared.showRoot(window: UIWindow(frame: UIScreen.main.bounds))
        return true
    }
}

public extension UINavigationBarAppearance {
    static var `default`: UINavigationBarAppearance {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .white

        let barButtonItemAppearance = UIBarButtonItemAppearance()
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.clear]

        navigationBarAppearance.backButtonAppearance = barButtonItemAppearance

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])

        let image = UIImage(systemName: "arrow.backward")?
            .withTintColor(.systemGray)
            .withRenderingMode(.alwaysOriginal)
        navigationBarAppearance.setBackIndicatorImage(image, transitionMaskImage: image)

        return navigationBarAppearance
    }
}
