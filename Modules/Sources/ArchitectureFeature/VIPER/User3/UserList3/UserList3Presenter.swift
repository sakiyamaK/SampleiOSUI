//
//  UserList3Presenter.swift
//  
//
//  Created by sakiyamaK on 2024/09/16.
//

import Foundation

public protocol UserList3Presenter {
    var initilalLoading: Bool { get }
    var refreshLoading: Bool { get }
    var users: [User] { get }
    
    func fetch()
    func select(indexPath: IndexPath)
    func changeValueRefreshControl()
}

@Observable
public final class UserList3PresenterImpl: UserList3Presenter {
    
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
    
    private let interactor: UserList3Interactor
    private unowned var router: UserList3Router
        
    init(
        interactor: UserList3Interactor,
        router: UserList3Router
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func fetch() {
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
