
//
//  VIPER.swift
//  Modules
//
//  Created by sakiyamaK on 2024/12/03.
//

import UIKit
import DeclarativeUIKit
import RxSwift
import RxCocoa
import NSObject_Rx

//MARK: - usecase
protocol ViperInteractorInput: Actor {
    var fetch: PublishRelay<Void> { get }
}

protocol ViperInteractorOutput: Actor {
    var item: BehaviorRelay<Int> { get }
    var itemValue: Int { get async }
}

protocol ViperUsecase: Actor {
    var inputs: ViperInteractorInput { get }
    var outputs: ViperInteractorOutput { get }
}

struct ViperInteractorDependency {
    var value: Int = 0
}

final actor ViperInteractor: HasDisposeBag, ViperInteractorInput, ViperInteractorOutput, ViperUsecase {
    var inputs: ViperInteractorInput { self }
    var outputs: ViperInteractorOutput { self }

    let fetch: PublishRelay<Void> = .init()
    let item: BehaviorRelay<Int>
    var itemValue: Int {
        get async {
            item.value
        }
    }

    init(dependency: ViperInteractorDependency) {
        item = .init(value: dependency.value)
        
//        disposeBag.insert([
//            fetch.bind(to: Binder(self) {_self, _ in
//                Task {
//                    let v = await _self.itemValue + 1
////                    _self.item.accept(v)
//                }
//            })
//        ])
    }
}


//MARK: - view
@MainActor
protocol ViperView: AnyObject {
    func hoge()
}

final class ViperViewController: UIViewController, ViperView {
    private(set) var presenter: ViperPresentation!
    func inject(presenter: ViperPresentation) {
        self.presenter = presenter
    }

    func hoge() {
        Task {
            let value = await presenter.outputs.value
            print(value)
        }
    }
    
    override func viewDidLoad() {
        Task {
            self.title = await presenter.outputs.value.description
        }
        self.declarative {
            UIButton(configuration: .bordered(), primaryAction: .init(title: "次へ", handler: {[weak self] _ in
                Task { @MainActor in
                    await self!.presenter.inputs.tapButton()
                }
            }))
            .center()
        }
    }
}
//MARK: - wireframe
@MainActor
protocol ViperWireframe: AnyObject, Sendable {
    func next(value: Int)
}

@MainActor
final class ViperRouter: ViperWireframe {
    deinit { print("Viper") }
    
    unowned let viewController: UIViewController
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

    static func assembleModules(dependency: ViperInteractorDependency = .init()) -> UIViewController {
        let view = ViperViewController()
        let router = ViperRouter(viewController: view)
        let interactor = ViperInteractor(
            dependency: dependency
        )
        let presenter = ViperPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.inject(presenter: presenter)

        return view
    }

    func next(value: Int) {
        let vc = ViperRouter.assembleModules(dependency: .init(value: value))
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - presentation
protocol ViperPresenterInput: Actor {
    func tapButton()
}
protocol ViperPresenterOutput: Actor {
    var value: Int { get async }
}
protocol ViperPresentation: AnyObject, Actor {
    var inputs: ViperPresenterInput { get }
    var outputs: ViperPresenterOutput { get }
}
final actor ViperPresenter: HasDisposeBag, ViperPresentation, ViperPresenterInput, ViperPresenterOutput {
    var inputs: ViperPresenterInput { self }
    var outputs: ViperPresenterOutput { self }
    
    private weak var view: ViperView?
    private let router: ViperWireframe
    private let interactor: ViperUsecase
    
    init(
        view: ViperView,
        interactor: ViperUsecase,
        router: ViperWireframe) {
            self.view = view
            self.interactor = interactor
            self.router = router
        }
    
    func tapButton() {
        Task { @MainActor in
            let v = await value
            let newValue = v+1
            print("values")
            print(v)
            print(newValue)
            router.next(value: newValue)
        }
    }
    
    var value: Int {
        get async {
            await interactor.outputs.itemValue
        }
    }

}

#Preview {
    UINavigationController(
        rootViewController: ViperRouter.assembleModules()
    )
}
