//
//  UserTab2Router.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit
import Extensions

public protocol UserTab2Router {
}

public final class UserTab2RouterImpl: UserTab2Router {
    
    deinit { print("\(Self.self) deinit") }

    private unowned var presenter: UserTab2Presenter!
    
    public static func assembleModules(isDummy: Bool = false) -> UserTab2Presenter {
        let interactor = UserTab2InteractorImpl()
        let router = UserTab2RouterImpl()
        let presenter = UserTab2PresenterImpl(
            interactor: interactor,
            router: router
        )
        presenter.viewControllers = [
            UserList2RouterImpl.assembleModules(
                isDummy: isDummy,
                tabBarItem: UITabBarItem(
                    title: "ホーム1",
                    image: UIImage(systemName: "house"),
                    tag: 0
                )
            ).withNavigationController,
            UserList2RouterImpl.assembleModules(
                isDummy: isDummy,
                tabBarItem: UITabBarItem(
                    title: "ホーム2",
                    image: UIImage(systemName: "house"),
                    tag: 1
                )
            ).withNavigationController,
            UserList2RouterImpl.assembleModules(
                isDummy: isDummy,
                tabBarItem: UITabBarItem(
                    title: "ホーム3",
                    image: UIImage(systemName: "house"),
                    tag: 2
                )
            ).withNavigationController
        ]
        router.presenter = presenter
        return presenter
    }
}

#Preview {
    MainActor.assumeIsolated {
        UserTab2RouterImpl.assembleModules(isDummy: true)
    }
}
