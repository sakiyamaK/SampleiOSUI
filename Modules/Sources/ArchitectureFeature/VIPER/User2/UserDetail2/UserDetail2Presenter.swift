//
//  UserDetail2Presenter.swift
//  
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit

public protocol UserDetail2Presenter: UIViewController {
    var user: User { get }
}

@Observable
public final class UserDetail2PresenterImpl: UIViewController, UserDetail2Presenter {
    
    deinit { print("\(Self.self) deinit") }

    public var user: User {
        interactor.user
    }
    
    private let interactor: UserDetail2Interactor
    private let router: UserDetail2Router
        
    init(
        view: UserDetail2View,
        interactor: UserDetail2Interactor,
        router: UserDetail2Router
    ) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(view)
        view.applyArroundConstraint(equalTo: self.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
