//
//  UserList2Router.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit

public protocol UserList2Router {
    func show(user: User)
}

public final class UserList2RouterImpl: UserList2Router {
    
    deinit { print("\(Self.self) deinit") }

    private unowned var presenter: UserList2Presenter!
    
    public static func assembleModules(isDummy: Bool = false, tabBarItem: UITabBarItem? = nil) -> UserList2Presenter {
        let view = UserList2ViewImpl()
        let interactor = UserList2InteractorImpl()
        interactor.isDummy = isDummy
        let router = UserList2RouterImpl()
        let presenter = UserList2PresenterImpl(
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
