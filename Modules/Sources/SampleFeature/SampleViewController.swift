import UIKit
import DeclarativeUIKit
import Extensions
import Components
import SwiftyAttributes
import RswiftResources
import RxSwift
import RxCocoa
import ObservableUIKit

public class SampleViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.applyView {
            $0.backgroundColor(.init(red255: 255, green255: 255, blue255: 255, alpha: 1.0))
        }
        .declarative {
            UIStackView.vertical {
                UIImageView()
                    .width(200)
                    .height(200)
                    .backgroundColor(.blue)
                    .customSpacing(16)
                
                UILabel(Array(repeating: "うおおおおお", count: 100).joined())
                    .customSpacing(16)

                UIButton(
                    configurationBuilder: {
                        UIButton.Configuration.borderedTinted()
                            .title("ボタンだよ")
                    }, primaryAction: .init(
                        handler: { _ in
                            DLog()
                        }
                    )
                )
            }
            .alignment(.center)
            .margins(.init(horizontal: 16))
            .center()
        }
        .declarative {
            AnimatedFloatingActionButton()
                .right()
                .bottom()
        }
    }
    
}

//@Observable
//class ViewModel {
//    var count: Int = 0
//}

//public class SampleViewController: UIViewController {
//    
//    let viewModel = ViewModel()
//    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        self.applyView({
//            $0.backgroundColor(.white)
//        }).declarative {
//            UIButton(configuration: .plain()).apply { button in
//                var config = UIButton.Configuration.filled().cornerStyle(.capsule).title("破線のボタンが作りたい")
//                config.background.cornerRadius = 10
//                config.background.strokeWidth = 2
//                config.background.strokeColor = .systemBlue
//                button.configuration = config
//            }
//            .center()
//        }.declarative {
//            UIButton(configuration: .plain().title("+").cornerStyle(.capsule))
//                .size(width: 50, height: 50)
//                .addAction(.touchUpInside) {[weak self] _ in
//                    self!.viewModel.count += 10
//                }
//                .right()
//                .bottom()
//                .offset(x: -12, y: -12)
//        }
//    }
//}
//
//// Copyright © The Chain Museum. All rights reserved.
//
//import UIKit
//import RxSwift
//import RxCocoa
//import NSObject_Rx
//
//final class ToggleButton: UIButton, HasDisposeBag {
//
//    let isActive = BehaviorRelay<Bool>(value: false)
//
//    func defaultConfiguration() -> UIButton.Configuration {
//        ToggleButton.defaultConfiguration()
//    }
//    
//    static func defaultConfiguration() -> UIButton.Configuration {
//        var config = UIButton.Configuration.filled()
//        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
//            var outgoing = incoming
//            outgoing.font = UIFont.defaultFontRegular(size: 12)
//            return outgoing
//        }
//        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
//        config.background.strokeWidth = 1.0
//        config.background.cornerRadius = 16
//        return config
//    }
//        
//    @discardableResult
//    func set(tap: @escaping ((Bool) -> Void)) -> Self {
//        return self
//    }
//
//    @discardableResult
//    func configure(isDefaultActive: Bool = false) -> Self {
//          isActive.subscribe(onNext: { [weak self] _ in
//              self?.setColor()
//          })
//          .disposed(by: disposeBag)
//
//          isActive.accept(isDefaultActive)
//        
//        return self
//      }
//
//    @discardableResult
//    func set(isActive: Bool) -> Self {
//        if self.isActive.value == isActive {
//            return self
//        }
//        self.isActive.accept(isActive)
//        return self
//    }
//
//    func setIsActive(isActive: Bool) {
//        if self.isActive.value == isActive {
//            return
//        }
//        self.isActive.accept(isActive)
//    }
//
//    private func setColor() {
//    }
//}

#Preview {
    SampleViewController()
}
