//
//  UserTab2Presenter.swift
//  
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit

public protocol UserTab2Presenter: UIViewController {
    var viewControllers: [UIViewController]? { set get }
    func viewDidLoad()
}

@Observable
public final class UserTab2PresenterImpl: UITabBarController, UserTab2Presenter {
    
    deinit { print("\(Self.self) deinit") }
    
    private let interactor: UserTab2Interactor
    private let router: UserTab2Router
        
    init(
        interactor: UserTab2Interactor,
        router: UserTab2Router
    ) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}
