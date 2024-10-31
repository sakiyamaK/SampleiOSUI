//
//  UserList4Router.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit

public protocol UserList4Router {
    func show(user: User)
}

public final class UserList4RouterImpl: UserList4Router {
    
    deinit { print("\(Self.self) deinit") }

    private unowned var presenter: UserList4Presenter!
    
    public static func assembleModules(isDummy: Bool = false, tabBarItem: UITabBarItem? = nil) -> UserList4Presenter {
        let view = UserList4ViewImpl()
        let interactor = UserList4InteractorImpl()
        interactor.isDummy = isDummy
        let router = UserList4RouterImpl()
        let presenter = UserList4PresenterImpl(
            view: view,
            tabBarItem: tabBarItem,
            interactor: interactor,
            router: router
        )
        view.setup(presenter: presenter)
        router.presenter = presenter
        return presenter
    }
    
    public func show(user: User) {
        let next = UserDetail2RouterImpl.assembleModules(user: user)
        self.presenter.navigationController?.pushViewController(next, animated: true)
    }
}
