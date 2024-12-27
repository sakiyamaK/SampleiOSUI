//
//  AsyncUIViewController.swift
//  Modules
//
//  Created by sakiyamaK on 2024/12/11.
//

import UIKit


class AsyncUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await viewDidLoad()
        }
    }
    
    open func viewDidLoad() async {
    }
}

final class TestAsyncUIViewController: AsyncUIViewController {

    let actor = ActorCounter()

    override func viewDidLoad() async {
        
        await super.viewDidLoad()

        try? await Task.sleep(nanoseconds: 100_000_000_000)
        await actor.increment()
        print((await actor.value).description)

        try? await Task.sleep(nanoseconds: 100_000_000_000)
        await actor.increment()
        print((await actor.value).description)
    }
}

#Preview {
    AsyncUIViewController()
}
