//
//  UserDetail2Router.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import Foundation

public protocol UserDetail2Router {
}

public final class UserDetail2RouterImpl: UserDetail2Router {
    
    deinit { print("\(Self.self) deinit") }
    
    private unowned var presenter: UserDetail2Presenter!
    
    public static func assembleModules(user: User) -> UserDetail2Presenter {
        let view = UserDetail2ViewImpl()
        let interactor = UserDetail2InteractorImpl(user: user)
        let router = UserDetail2RouterImpl()
        let presenter = UserDetail2PresenterImpl(
            view: view,
            interactor: interactor,
            router: router
        )
        view.setup(presenter: presenter)
        router.presenter = presenter
        return presenter
    }
}
