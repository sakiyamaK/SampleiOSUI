//
//  UserDetail2Interactor.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import Foundation
import Utils

public protocol UserDetail2Interactor {
    var user: User { get }
}

@Observable
public final class UserDetail2InteractorImpl: UserDetail2Interactor {
    
    deinit { print("\(Self.self) deinit") }
    
    public private(set) var user: User
    init(user: User) {
        self.user = user
    }
}
