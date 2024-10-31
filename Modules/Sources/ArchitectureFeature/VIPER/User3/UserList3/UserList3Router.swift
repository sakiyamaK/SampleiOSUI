//
//  UserList3Router.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit

public protocol UserList3Router: UIViewController {
    func viewDidLoad()
    func show(user: User)
}

public final class UserList3RouterImpl: UIViewController, UserList3Router {
    
    deinit { print("\(Self.self) deinit") }
    
    private var presenter: UserList3Presenter!
    public static func assembleModules() -> UIViewController {
        let view = UserList3ViewImpl()
        let interactor = UserList3InteractorImpl()
        let router = UserList3RouterImpl()
        let presenter = UserList3PresenterImpl(
            interactor: interactor,
            router: router
        )
        router.presenter = presenter
        router.view.addSubview(view)
        view.applyArroundConstraint(equalTo: router.view)
        view.setup(with: presenter)
        return router
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetch()
    }
    
    public func show(user: User) {
        
    }
}
