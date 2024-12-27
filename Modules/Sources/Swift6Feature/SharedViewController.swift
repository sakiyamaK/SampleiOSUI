//
//  Swift6ViewController.swift
//  Modules
//
//  Created by sakiyamaK on 2024/12/02.
//

import UIKit
import DeclarativeUIKit
import Extensions
import Components
import SwiftyAttributes
import RxSwift
import RxCocoa

actor ClassCounter {
    static let `default`: ClassCounter = .init()
    private init() {}
    var value: Int = 0
    func increment() async -> Int {
        try? await Task.sleep(nanoseconds: 500_000_000)
        value += 1
        return value
    }
}

public class SharedViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyView {
            $0.backgroundColor(.white)
        }.declarative {
            
            UIStackView.vertical {
                UIButton(configuration: .plain(), primaryAction: .init(title: "tap", handler: {_ in
                    print("tap")
                    Task {
                        let counter = ClassCounter.default
                        print(await counter.increment())
                    }
                }))
            }
            .spacing(20)
            .center()
        }
    }
}

#Preview {
    SharedViewController()
}
