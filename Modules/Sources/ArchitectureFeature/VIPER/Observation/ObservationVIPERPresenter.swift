//
//  ObservationVIPERPresenter.swift
//  
//
//  Created by sakiyamaK on 2024/09/16.
//

import Foundation

public protocol ObservationVIPERPresenter {
    var loading: Bool { get }
    var users: [User] { get }
    
    func viewDidLoad()
    func select(indexPath: IndexPath)
}

@Observable
public final class ObservationVIPERPresenterImpl: ObservationVIPERPresenter {
    
    public var loading: Bool { interactor.loading }
    public var users: [User] { interactor.users }
    
    private let view: ObservationVIPERView
    private let interactor: ObservationVIPERInteractor
    private let router: ObservationVIPERRouter
        
    init(
        view: ObservationVIPERView,
        interactor: ObservationVIPERInteractor,
        router: ObservationVIPERRouter
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    public func viewDidLoad() {
        Task {
            await self.interactor.fetch()
        }
    }
    
    public func select(indexPath: IndexPath) {
        router.show(user: users[indexPath.item])
    }
}
