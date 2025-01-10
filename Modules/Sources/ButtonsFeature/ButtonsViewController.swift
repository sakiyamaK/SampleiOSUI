//
//  ButtonsViewController.swift
//  
//
//  Created by sakiyamaK on 2024/10/09.
//

import UIKit
import DeclarativeUIKit
import Extensions
import Components
import SwiftyAttributes
import ObservableUIKit
import Files

public class ButtonsViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        var button: UIButton!
        
        self.applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UIScrollView {
                
                UIStackView {
                    
                    UIButton(assign: &button)
                        .configuration {
                            var config = UIButton.Configuration.bordered()
                            config.cornerStyle = .fixed
                            config.title = "lufy"
                            config.image = UIImage(named: "lufy", in: .module, with: .none)?.withRenderingMode(.alwaysTemplate)
                            config.imageColorTransformer =
                            UIConfigurationColorTransformer { color in
                                DLog("hoge")
                                switch button.state {
                                case .highlighted:
                                    return color.withAlphaComponent(0.5)
                                default:
                                    return color
                                }
                            }
                            return config
                        }
                        .configurationUpdateHandler { button in
                        }

                    UIButton(
                        configuration:
                                .plain()
                                .image(.checkmark)
                                .imagePadding(4)
                                .attributedTitle(.init(string: "Checkmark").withTextColor(.red)),
                        primaryAction: .init(handler: {
                            action in
                            let button = action.sender as? UIButton
                            button?.configuration = button?.configuration?.title("hoge")
                        })
                    )
                    .planBackgroundColors()

                    UIButton(
                        configuration:
                                .plain()
                                .image(.checkmark)
                                .imagePadding(4)
                                .attributedTitle(.init(string: "Checkmark"))
//                        primaryAction: .init(
//                            handler: {
//                                _ in DLog("Checkmark")
//                            })
                    )
                    .planBackgroundColors()
                    .showsMenuAsPrimaryAction(true)
                    .menu(UIMenu(options: .displayInline, children: [
                        UIDeferredMenuElement.uncached { completion in
                            completion(["hoge", "hige", "hage"].compactMap {[weak self] sortType in
                                UIAction(
                                    title: sortType,
                                    state: "hoge" == sortType ? .on : .off
                                ) {[weak self] _ in
                                    DLog("hogee")
                                }
                            })
                        }
                    ]))

                    
                    UIButton(
                        configuration:
                                .plain()
                    )
                    .planBackgroundColors()
                    .addAction(.touchUpInside, handler: { _ in
                        DLog("A")
                    })
                    .addAction(.touchUpInside, handler: { _ in
                        DLog("B")
                    })
//                    .configurationUpdateHandler({ button in
//                        DLog(button.state)
//                        DLog(button.configuration)
//                        let background = switch button.state {
//                        case .highlighted:
//                            UIBackgroundConfiguration.clear()
//                                .backgroundColor(.red)
//                        default:
//                            UIBackgroundConfiguration.clear()
//                                .backgroundColor(.clear)
//                        }
//
//                        button.configuration?.background = background
//
////                        switch button.state {
////                        case .highlighted:
////                            button.configuration = button.configuration?.background(.clear().backgroundColor(.red))
////                        default:
////                            button.configuration = button.configuration?.background(.clear().backgroundColor(.clear))
////                        }
//                    })
                    .zStack({
                        UIStackView.vertical {
                            UILabel("hogeeee")
                                .contentPriorities(.init(all: .required))
                            UILabel("hogeeee")
                                .contentPriorities(.init(all: .required))
                            UILabel("hogeeee")
                                .contentPriorities(.init(all: .required))
                        }
                        .isUserInteractionEnabled(false)
                    })
                    .width(200)
                    .height(300)
                    
                    UIButton(
                        configuration:
//                                .tinted()
//                            .bordered()
                            .borderedProminent()
//                            .borderless()
                                .attributedTitle(
                                    "hogee".withFont(UIFont.defaultFontBold(size: 40))
                                )
                                .baseBackgroundColor(.black)
                                .baseForegroundColor(.white)
                                .cornerStyle(.capsule)
                    )
                    .isEnabled(false)
                    .padding()
                    .backgroundColor(.red)
                    
                    UIButton(
                        configuration:
                                .borderless()
                                .attributedTitle(
                                    "作品購入で何かお困りですか？"
                                        .withFont(UIFont.defaultFontMedium(size: 12))
                                )
//                                .baseBackgroundColor(.clear)
                                .baseForegroundColor(.systemGreen)
//                                .contentInsets(.zero)
                    ).configurationUpdateHandler({ button in
                        let background = switch button.state {
                        case .highlighted:
                            UIBackgroundConfiguration.clear()
                                .backgroundColor(.lightGray.withAlphaComponent(0.5))
                        default:
                            UIBackgroundConfiguration.clear()
                        }
                        
                        button.configuration?.background = background

                    }
                    )
                    .padding(insets: .init(all: 20))
                    .backgroundColor(.red)
                                        
                    UIButton(
                        configuration: .capsule(
                            title: "もっと見る",
                            titleColor: .white,
                            font: .defaultFontRegular(size: 14),
//                            strokeColor: .black,
                            image: UIImage(systemName: "arrow.2.circlepath"),
                            imagePadding: 16,
                            backgroundColor: .black,
                            contentInsets: .init(horizontal: 16, vertical: 9)
                        )
                    )
                    .isEnabled(false)
                    .height(36)
                    .shadow(color: .black.withAlphaComponent(0.5), radius: 4, x: 0, y: 2)
                    .addAction(.touchUpInside) { buttonAction in
                        print("tap")
                        //                    (buttonAction.sender as! UIButton).isEnabled = false
                    }

                    
                    UIButton(
                        configuration: .bordered()
                            .attributedTitle("背景色が等価されてる".withFont(.defaultFontMedium(size: 16)))
                            .background(.clear().cornerRadius(0))
                    )
                    .height(100)
                    .padding()
                    .backgroundColor(.red)
                    
                    UIButton(
                        configuration: .plain()
                            .attributedTitle("背景色が等価されてる".withFont(.defaultFontMedium(size: 16)))
                            .background(.clear().backgroundColor(.green))
                    )
                    .apply({ button in
                    })
                    .height(100)
                    
                    UIButton(
                        configuration:
                                .plain()
                                .image(UIImage(resource: .btnLoginFb))
                                .preferredSymbolConfigurationForImage(.init(pointSize: 50))
                    )
                    .configurationUpdateHandler({ button in
                        let background = switch button.state {
                        case .highlighted:
                            UIBackgroundConfiguration.clear()
                                .backgroundColor(.lightGray.withAlphaComponent(0.5))
                        default:
                            UIBackgroundConfiguration.clear()
                        }
                        
                        button.configuration?.background = background

                    })
                    .size(width: 50, height: 50)
                    
                    UIButton(
                        configuration:
                                .plain()
                                .image(UIImage(resource: .btnLoginApple))
                                .preferredSymbolConfigurationForImage(.init(pointSize: 50))
//                                .imagePadding(0)
                                .contentInsets(.zero)
                    )
                    .configurationUpdateHandler(
                        { button in
                            let image: UIImage? = switch button.state {
                            case .highlighted:
                                UIImage(resource: .btnLoginApple)
                                    .with(
                                        overlayColor: .gray
                                            .withAlphaComponent(0.5)
                                    )!
                        default:
                                UIImage(resource: .btnLoginApple)
                                    .with(
                                        overlayColor: .gray
                                            .withAlphaComponent(0.0)
                                    )!
                        }
                        
                        button.configuration?.image = image

                    })
                }
                .alignment(.center)
                .spacing(20)
                .centerX()
            }
        }
    }
}

#Preview {
    ButtonsViewController()
}
