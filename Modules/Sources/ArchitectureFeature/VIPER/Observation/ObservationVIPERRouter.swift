//
//  ObservationVIPERRouter.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import Foundation

public protocol ObservationVIPERRouter {
    func show(user: User)
}

public final class ObservationVIPERRouterImpl: ObservationVIPERRouter {
    
    private unowned var viewController: ObservationVIPERView!
    init(viewController: ObservationVIPERView!) {
        self.viewController = viewController
    }
    
    public static func assembleModules() -> ObservationVIPERView {
        let view = ObservationVIPERViewImpl()
        let interactor = ObservationVIPERInteractorImpl()
        let router = ObservationVIPERRouterImpl(viewController: view)
        let presenter = ObservationVIPERPresenterImpl(
            view: view,
            interactor: interactor,
            router: router
        )
        view.inject(
            presenter: presenter
        )
        return view
    }
    
    public func show(user: User) {
        
    }
}
