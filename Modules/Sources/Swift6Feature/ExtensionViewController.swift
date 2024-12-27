//
//  ExtensionViewController.swift
//  Modules
//
//  Created by sakiyamaK on 2024/12/03.
//


import UIKit
import DeclarativeUIKit
import RxSwift
import RxCocoa
import NSObject_Rx

extension ObservableType where Element == Void {
    func handleError(for viewController: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) -> Disposable {
        observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                [weak viewController] _ in
                guard let viewController else { return }
                Task { @MainActor in
                    print("how")
                    viewController.presentErrorAlert(handler: nil)

                }
        })
    }
}

final class LoadingView: UIView {
    
    static let shared = LoadingView()
    
    func show() {
        self.backgroundColor = .red
    }
    
    func hide() {
        self.backgroundColor = .clear
    }

}

extension ObservableType where Element == Bool {
    
    // デフォは0.5sec以内にローディングが終わっていれば出さない
    func handleLoading(waitingMilliseconds: Int = 500) -> Disposable {
        observe(on: MainScheduler.instance)
            .debounce(RxTimeInterval.milliseconds(waitingMilliseconds), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                Task { @MainActor in
                    if value {
                        LoadingView.shared.show()
                    } else {
                        LoadingView.shared.hide()
                    }
                }
            })
    }
}

protocol NewsFetcherInputProtocol: Actor {
    var fetch: PublishRelay<Int> { get }
}
actor NewsFetcher: NewsFetcherInputProtocol, HasDisposeBag {
    static let shared = NewsFetcher()
    
    // input
    let fetch: PublishRelay<Int> = .init()
    
    private init () {
                
        fetch.asObservable().bind(to: Binder(self) {_,_  in
            print("")
        }).disposed(by: disposeBag)
//        disposeBag.insert {
//            fetch.asObservable().bind(to: Binder(self) {_,_  in
//                print("")
//            })
//        }
    }
}

@resultBuilder
public enum ArrayDisposeBuilder {
    public typealias Component = [Expression]
    public typealias Expression = Disposable

    public static func buildExpression(_ element: Expression) -> Component {
        return [element]
    }

    public static func buildExpression(_ component: Component) -> Component {
        return component
    }

    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else { return [] }
        return component
    }

    public static func buildEither(first component: Component) -> Component {
        return component
    }

    public static func buildEither(second component: Component) -> Component {
        return component
    }

    public static func buildArray(_ components: [Component]) -> Component {
        return Array(components.joined())
    }

    public static func buildBlock(_ components: Component...) -> Component {
        return Array(components.joined())
    }
    
    public static func buildBlock() -> Component {
        return []
    }
}

public extension DisposeBag {
    
    func inserts(@ArrayDisposeBuilder _ builder: () -> [Disposable]) {
        let arr = builder()
        self.insert(arr)
    }
}

actor Hoge {
    let hige: PublishRelay<Int> = .init()
    let hage: PublishRelay<Int> = .init()
    
    let disposeBag: DisposeBag = .init()
    
    private init () {
        disposeBag.insert([
            hige.asObservable().subscribe { v in
                print(v)
            }
        ])
    }
}


extension UIViewController {
    func presentErrorAlert(handler: ((UIAlertAction) -> Void)? = nil) {

        self.present(UIAlertController(title: "タイトル", message: "メッセージ", preferredStyle: .alert)
            .addActions {
                UIAlertAction(title: "ok", style: .default) { action in
                    handler?(action)
                }
                UIAlertAction(title: "close", style: .cancel) { action in
                    handler?(action)
                }
            }, animated: true)
    }
}

final class ExtensionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.declarative {
            UIStackView.vertical {
                UIButton(configuration: .plain(), primaryAction: .init(title: "alert", handler: {[weak self] _ in
                    print("alert")
                    _ = Observable.just(()).handleError(for: self!)
//                    self!.presentErrorAlert()
                }))
            }
            .center()
        }
    }
}

#Preview {
    ExtensionViewController()
}
