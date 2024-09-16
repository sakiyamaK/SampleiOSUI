import UIKit
import DeclarativeUIKit
import Extensions
import Components
import SwiftyAttributes
import RxSwift
import RxCocoa
import ObservableUIKit
import Files

public class SampleViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.applyView {
            $0.backgroundColor(.white)
        }
        .declarative {
            UIImageView(image: R.otherPackage.image.aho())
                .zStack {
                    UIStackView.vertical {
                        UIButton(
                            configurationBuilder: {
                                var backgroundConfig = UIBackgroundConfiguration.clear()
                                backgroundConfig.strokeColor = .borderColor
                                backgroundConfig.strokeWidth = 1.0
                                return UIButton.Configuration.filled()
                                    .title("Next")
                                    .titleTextAttributesTransformer(.init({
                                        var trans = $0
                                        trans.font = .defaultFontBold(size: 24)
                                        return trans
                                    }))
                                    .baseBackgroundColor(.white)
                                    .baseForegroundColor(.black)
                                    .cornerStyle(.capsule)
                                    .contentInsets(.init(top: 8, leading: 24, bottom: 8, trailing: 24))
                                    .background(backgroundConfig)
                            }, primaryAction: .init(
                                handler: { _ in
                                    DLog()
                                }
                            )
                        )
                        .height(44)
                        
                        UILabel("245 Favorite")
                            .font(.defaultFontRegular(size: 12))
                            .textAlignment(.center)
                            .contentPriorities(.init(vertical: .required))
                        
                        UIButton(
                            configurationBuilder: {
                                var backgroundConfig = UIBackgroundConfiguration.clear()
                                backgroundConfig.strokeColor = .borderColor
                                backgroundConfig.strokeWidth = 1.0
                                return UIButton.Configuration.filled()
                                    .title("Next")
                                    .titleTextAttributesTransformer(.init({
                                        var trans = $0
                                        trans.font = .defaultFontBold(size: 14)
                                        return trans
                                    }))
                                    .baseBackgroundColor(.borderColor)
                                    .baseForegroundColor(.black)
                                    .cornerStyle(.capsule)
//                                    .contentInsets(.init(all: 10))
                                    .background(backgroundConfig)
                            }, primaryAction: .init(
                                handler: { _ in
                                    DLog()
                                }
                            )
                        )
                        .height(44)
                        
                        UIButton(
                            configurationBuilder: {
                                return UIButton.Configuration.filled()
                                    .title("Skip")
                                    .baseBackgroundColor(.black.withAlphaComponent(0.2))
                                    .baseForegroundColor(.white)
                                    .cornerStyle(.capsule)
                                    .titleAlignment(.leading)
                                    .titleTextAttributesTransformer(.init({
                                        var trans = $0
                                        trans.font = .defaultFontRegular(size: 12)
                                        return trans
                                    }))
                                    .contentInsets(.init(top: 4, leading: 10, bottom: 4, trailing: 10))
                            }
                            , primaryAction: .init(
                                handler: {_ in
                                }
                            )
                        )
                    }
                    .alignment(.center)
                    .spacing(10)
                    .margins(.init(horizontal: 16))
                    .centerY()
                }
        }
    }
}

extension UIButton.Configuration {
    @discardableResult
    func attributedTitle(_ attributedTitle: NSMutableAttributedString?) -> Self {
        var _self = self
        guard let attributedTitle else { return _self }
        let nsAttributedString = NSAttributedString(attributedString: attributedTitle)
        let attributedString = AttributedString(nsAttributedString)
        _self.attributedTitle = attributedString
        return _self
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
