//
//  UserList3Interactor.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import Foundation
import Utils

public protocol UserList3Interactor {
    var loading: Bool { get }
    var users: [User]? { get }
    var initilalLoading: Bool { get }
    var refreshLoading: Bool { get }
    func fetch() async
}

@Observable
public final class UserList3InteractorImpl: UserList3Interactor {
    
    deinit { print("\(Self.self) deinit") }

    public private(set) var loading: Bool = true
    public private(set) var users: [User]?
    public var initilalLoading: Bool {
        users == nil && loading
    }
    public var refreshLoading: Bool {
        users != nil && loading
    }

    public func fetch() async {
        defer {
            loading = false
        }
        
        do {
            loading = true
            // 0.5秒遅らせる
            let delayInNanoseconds = 500_000_000 // 500ミリ秒をナノ秒に変換
            try await Task.sleep(nanoseconds: UInt64(delayInNanoseconds))
            users = try await API.shared.getUsers()
        } catch let e {
            users = []
            DLog(e)
        }
    }

}
