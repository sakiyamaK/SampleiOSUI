//
//  ObservationObservationViper.swift
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
protocol ObservationViperInteractorInput: Actor {
    func fetch()
}

protocol ObservationViperInteractorOutput: Actor {
    var item: Int { get }
}

protocol ObservationViperUsecase: Actor {
    var inputs: ObservationViperInteractorInput { get }
    var outputs: ObservationViperInteractorOutput { get }
}

struct ObservationViperInteractorDependency {
    var value: Int = 0
}

final actor ObservationViperInteractor: HasDisposeBag, ObservationViperInteractorInput, ObservationViperInteractorOutput, ObservationViperUsecase {
    var inputs: ObservationViperInteractorInput { self }
    var outputs: ObservationViperInteractorOutput { self }

    let fetch: PublishRelay<Void> = .init()
    let item: BehaviorRelay<Int>
    var itemValue: Int {
        get async {
            item.value
        }
    }

    init(dependency: ObservationViperInteractorDependency) {
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
protocol ObservationViperView: AnyObject {
    func hoge()
}

final class ObservationViperViewController: UIViewController, ObservationViperView {
    private(set) var presenter: ObservationViperPresentation!
    func inject(presenter: ObservationViperPresentation) {
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
protocol ObservationViperWireframe: AnyObject, Sendable {
    func next(value: Int)
}

@MainActor
final class ObservationViperRouter: ObservationViperWireframe {
    deinit { print("ObservationViper") }
    
    unowned let viewController: UIViewController
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

    static func assembleModules(dependency: ObservationViperInteractorDependency = .init()) -> UIViewController {
        let view = ObservationViperViewController()
        let router = ObservationViperRouter(viewController: view)
        let interactor = ObservationViperInteractor(
            dependency: dependency
        )
        let presenter = ObservationViperPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.inject(presenter: presenter)

        return view
    }

    func next(value: Int) {
        let vc = ObservationViperRouter.assembleModules(dependency: .init(value: value))
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - presentation
protocol ObservationViperPresenterInput: Actor {
    func tapButton()
}
protocol ObservationViperPresenterOutput: Actor {
    var value: Int { get async }
}
protocol ObservationViperPresentation: AnyObject, Actor {
    var inputs: ObservationViperPresenterInput { get }
    var outputs: ObservationViperPresenterOutput { get }
}
final actor ObservationViperPresenter: HasDisposeBag, ObservationViperPresentation, ObservationViperPresenterInput, ObservationViperPresenterOutput {
    var inputs: ObservationViperPresenterInput { self }
    var outputs: ObservationViperPresenterOutput { self }
    
    private weak var view: ObservationViperView?
    private let router: ObservationViperWireframe
    private let interactor: ObservationViperUsecase
    
    init(
        view: ObservationViperView,
        interactor: ObservationViperUsecase,
        router: ObservationViperWireframe) {
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
        rootViewController: ObservationViperRouter.assembleModules()
    )
}
