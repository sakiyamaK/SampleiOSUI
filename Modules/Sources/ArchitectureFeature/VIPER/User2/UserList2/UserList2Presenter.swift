//
//  UserList2Presenter.swift
//  
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit

public protocol UserList2Presenter: UIViewController {
    var initilalLoading: Bool { get }
    var refreshLoading: Bool { get }
    var users: [User] { get }
    
    func select(indexPath: IndexPath)
    func changeValueRefreshControl()
}

@Observable
public final class UserList2PresenterImpl: UIViewController, UserList2Presenter {
    
    deinit { print("\(Self.self) deinit") }

    public var initilalLoading: Bool {
        interactor.initilalLoading
    }
    public var refreshLoading: Bool {
        interactor.refreshLoading
    }
    public var users: [User] {
        interactor.users ?? []
    }
    
    private let interactor: UserList2Interactor
    private let router: UserList2Router
        
    init(
        view: UserList2View,
        tabBarItem: UITabBarItem?,
        interactor: UserList2Interactor,
        router: UserList2Router
    ) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(view)
        view.applyArroundConstraint(equalTo: self.view)
        
        self.tabBarItem = tabBarItem
        self.title = tabBarItem?.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await self.interactor.fetch()
        }
    }

    public func changeValueRefreshControl() {
        Task {
            await self.interactor.fetch()
        }
    }

    public func select(indexPath: IndexPath) {
        router.show(user: users[indexPath.item])
    }    
}
