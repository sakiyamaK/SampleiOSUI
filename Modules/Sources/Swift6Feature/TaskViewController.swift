//
//  TaskViewController.swift
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


public class TaskViewController: UIViewController {
    
    let api: API = .init()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyView {
            $0.backgroundColor(.white)
        }.declarative {
            
            UIStackView.vertical {
                
                UIButton(
                    configuration: .bordered()
                            .title("fetchOnceSync"),
                    primaryAction: .init(handler: {_ in
                        print("fetchOnceSync")
                        Task {
                            do {
                                let results = try await self.api.fetchOnceSync(delays: [1, 1, 1, 1, 1], sendError: true)
                                print("results: \(results)")
                            } catch let e {
                                print(e.localizedDescription)
                            }
                        }
                    })
                )
                
                UIButton(
                    configuration: .bordered()
                            .title("fetchOnceAsync"),
                    primaryAction: .init(handler: {_ in
                        print("fetchOnceAsync")
                        Task {
                            do {
                                let result = try await self.api.fetchOnceAsync(delays: [1, 1, 1, 1, 1], sendError: false)
                                print(result)
                            } catch let e {
                                print(e.localizedDescription)
                            }
                        }
                    })
                )

            }
            .spacing(20)
            .center()
        }
    }
}

#Preview {
    TaskViewController()
}
