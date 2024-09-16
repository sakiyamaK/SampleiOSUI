//
//  ObservationVIPERInteractor.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import Foundation
import Utils

public protocol ObservationVIPERInteractor {
    var loading: Bool { get }
    var users: [User] { get }
    func fetch() async
}

@Observable
public final class ObservationVIPERInteractorImpl: ObservationVIPERInteractor {
    public private(set) var loading: Bool = true
    public private(set) var users: [User] = []
    
    public func fetch() async {
        defer {
            loading = false
        }
        do {
            loading = true
            users = try await API.shared.getUsers()
        } catch let e {
            DLog(e)
        }
    }

}
