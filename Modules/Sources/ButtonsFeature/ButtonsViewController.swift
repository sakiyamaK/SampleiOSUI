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
                                    .with(color: .gray.withAlphaComponent(0.5))
                        default:
                                UIImage(resource: .btnLoginApple)
                                .with(color: .gray.withAlphaComponent(0.0))
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

// Copyright © The Chain Museum. All rights reserved.

import UIKit

public extension UIButton {

    @discardableResult
    func imageButtonBackgroundColors(
        image: UIImage?,
        default defaultColor: UIColor = .ViewBackground.clear,
        highlighted hilightedColor: UIColor? = .Button.hilighted
    ) -> Self {
        self.configurationUpdateHandler({ button in
            let image: UIImage? = switch button.state {
            case .highlighted:
                // withTintColorでは半透明ができない
                image.with(color: hilightedColor)
            default:
                // withTintColorでは半透明ができない
                image.with(color: defaultColor)
            }
            button.configuration?.image = image
        })
        return self
    }
    
    @discardableResult
    func textBackgroundColors(
        default defaultColor: UIColor = .Button.white,
        highlighted hilightedColor: UIColor? = .Button.hilighted
    ) -> Self {
        self.configurationUpdateHandler({ button in

            let background = switch button.state {
            case .highlighted:
                UIBackgroundConfiguration.clear()
                    .backgroundColor(hilightedColor)
            default:
                UIBackgroundConfiguration.clear()
                    .backgroundColor(defaultColor)
            }

            button.configuration?.background = background
        })
        return self
    }
    
    @discardableResult
    public func planBackgroundColors(
        default defaultColor: UIColor = .Button.white,
        highlighted hilightedColor: UIColor? = .Button.hilighted
    ) -> Self {
        self.textBackgroundColors(default: defaultColor, highlighted: hilightedColor)
    }
}

extension UIButton.Configuration {

    public static func capsule(
        title: String,
        titleColor: UIColor = .Text.main,
        font: UIFont = .defaultFontMedium(size: 14),
        strokeColor: UIColor = .ViewBackground.whiteBorder,
        image: UIImage? = nil,
        imagePadding: CGFloat = 12,
        backgroundColor: UIColor = .ViewBackground.main,
        contentInsets: NSDirectionalEdgeInsets = .init(horizontal: 16)
    ) -> UIButton.Configuration {
        .borderedProminent()
        .cornerStyle(.capsule)
        .attributedTitle(title.withFont(font))
        .image(image)
        .imagePadding(imagePadding)
        .background(.clear().strokeColor(strokeColor).strokeWidth(1))
        .baseBackgroundColor(backgroundColor)
        .baseForegroundColor(titleColor)
        .contentInsets(contentInsets)
    }
    
    public static func text(
        title: String,
        titleColor: UIColor = .Text.main,
        font: UIFont = .defaultFontMedium(size: 14),
        backgroundColor: UIColor = .ViewBackground.clear,
        contentInsets: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    ) -> UIButton.Configuration {
        .borderedProminent()
        .attributedTitle(title.withFont(font))
        .baseForegroundColor(titleColor)
        .baseBackgroundColor(backgroundColor)
        .contentInsets(contentInsets)
    }
    
    public static func image(
        icon: UIImage? = nil,
        iconSize: CGFloat,
        backgroundColor: UIColor = .ViewBackground.clear,
        contentInsets: NSDirectionalEdgeInsets = .zero
    ) -> UIButton.Configuration {
        .plain()
        .image(icon)
        .preferredSymbolConfigurationForImage(.init(pointSize: iconSize))
        .baseBackgroundColor(backgroundColor)
        .contentInsets(contentInsets)
    }

}


public extension UIColor {

    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    /// 適合ケース
    /// ex. #FFF FFF #FFFFFF FFFFFF
    convenience init(hex: String, alpha: CGFloat) {

        let hexCode = hex.replacingOccurrences(of: "#", with: "")

        if hexCode.count == 3 {
            let v: [String] = hexCode.map { String($0) }
            let r: CGFloat = CGFloat(Int(v[0], radix: 16) ?? 0) / 15.0
            let g: CGFloat = CGFloat(Int(v[1], radix: 16) ?? 0) / 15.0
            let b: CGFloat = CGFloat(Int(v[2], radix: 16) ?? 0) / 15.0
            self.init(red: r, green: g, blue: b, alpha: alpha)
        } else if hexCode.count == 6 {
            let v: [String] = hexCode.map { String($0) }
            let r: CGFloat = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
            let g: CGFloat = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
            let b: CGFloat = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
            self.init(red: r, green: g, blue: b, alpha: alpha)
        } else {
            // 失敗
            self.init(white: 1, alpha: 1)
        }
    }

    convenience init(red255: CGFloat, green255: CGFloat, blue255: CGFloat, alpha: CGFloat) {
        self.init(red: red255/255, green: green255/255, blue: blue255/255, alpha: alpha)
    }

    // 丸の画像にする
    func circleImage(width: CGFloat, height: CGFloat, margin: UIEdgeInsets = .zero) -> UIImage {
        let rect = CGRect(x: margin.left, y: margin.top, width: width, height: height)
        let size = CGSize(width: width + margin.left + margin.right, height: height + margin.top + margin.bottom)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.setFillColor(self.cgColor)
        contextRef?.fillEllipse(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    var cssColor: String {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        var alpha: CGFloat = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let red255: Int = Int(red * 255)
        let green255: Int = Int(green * 255)
        let blue255: Int = Int(blue * 255)
        return "RGB(\(red255),\(green255),\(blue255));"
    }
}

public extension UIColor {
    static let grayColor1: UIColor = .init(hex: 0xe5e5e5)
    static let grayColor2: UIColor = .init(hex: 0xe4e4e4)
    static let grayColor3: UIColor = .init(hex: 0x888888)
    static let grayColor4: UIColor = .init(hex: 0xeeeeee)
    static let grayColor5: UIColor = .init(hex: 0xcccccc)
    static let grayColor6: UIColor = .init(hex: 0x9a9a9a)
    static let grayColor7: UIColor = .init(hex: 0xd8d8d8)
    static let grayColor8: UIColor = .init(hex: 0xefeff4)
    
    static let blackColor1: UIColor = .init(hex: 0x000000)
    static let blackColor2: UIColor = .init(hex: 0x333333)
    static let blackColor3: UIColor = .init(hex: 0x323232)
    static let blackColor4: UIColor = .init(hex: 0x1a1a1a)
    
    static let redColor1: UIColor = .init(hex: 0xff4f59)
    static let redColor2: UIColor = .red
    static let redColor3: UIColor = .init(hex: 0xdc414a)
    static let redColor4: UIColor = .init(hex: 0xff303c)

    static let greenColor1: UIColor = .init(hex: 0x13857c)
    static let greenColor2: UIColor = .init(hex: 0x5baca6)
    static let greenColor3: UIColor = .init(hex: 0x06c755)
    
    static let yellowColor1: UIColor = .init(hex: 0xf0e600)
    
    static let whiteColor1: UIColor = .init(hex: 0xffffff)
    static let whiteColor2: UIColor = .init(hex: 0xeeffff)
    static let whiteColor3: UIColor = .init(hex: 0xf2f2f2)
    static let whiteColor4: UIColor = .init(hex: 0xf9f9f9)
    static let whiteColor5: UIColor = .init(hex: 0xf5f5f5)

    static let blueColor1: UIColor = .init(hex: 0x1da1f2)
    static let blueColor2: UIColor = .init(hex: 0x1877f2)

    enum Text {
        public static let main: UIColor = .blackColor1
        public static let sub: UIColor = .grayColor3
        public static let subSub: UIColor = .grayColor5
        public static let mainWhite: UIColor = .whiteColor1
        public static let link: UIColor = .greenColor1
    }
    //いずれ消す-----
    static let mainTextColor: UIColor = Text.main
    static let subTextColor: UIColor = Text.sub
    static let subSubTextColor: UIColor = Text.subSub
    static let mainWhiteTextColor: UIColor = Text.mainWhite
    static let textLinkColor: UIColor = Text.link
    //いずれ消す----ここまで
    
    enum ViewBackground {
        public static let main: UIColor = .whiteColor1
        public static let mainGray: UIColor = .grayColor4
        public static let mainBlack: UIColor = .blackColor1
        public static let tableView: UIColor = .whiteColor4
        public static let notificationCell: UIColor = .grayColor4
        public static let picker: UIColor = .grayColor8.withAlphaComponent(0.94)
        public static let instaStroeies: UIColor = .whiteColor4
        public static let hasUnreadMessageCell: UIColor = .grayColor4
        public static let snackbar: UIColor = .blackColor2
        public static let settingRoot: UIColor = .grayColor4
        public static let clear: UIColor = .clear
        public static let separator: UIColor = .grayColor1
        public static let border: UIColor = .grayColor1
        public static let grayBorder: UIColor = .grayColor5
        public static let whiteBorder: UIColor = .whiteColor3
        public static let bar: UIColor = .grayColor3
        public static let searchBar: UIColor = .grayColor4
        public static let badge: UIColor = .redColor1
        public static let hilighted: UIColor = .grayColor1
        public static let grayHilighted: UIColor = .grayColor5
        public static let twitter: UIColor = .blackColor1
        public static let facebook: UIColor = .blueColor2
        public static let line: UIColor = .greenColor3
        public static let attention: UIColor = .redColor1
    }
    
    enum PageControl {
        public static let currentPageIndicatorTintColor = UIColor.blackColor1
        public static let tintColor = UIColor.grayColor7
    }
    
    //いずれ消す-----
    static let mainViewBackgroundColor: UIColor = ViewBackground.main
    static let grayBackgroundColor: UIColor = ViewBackground.mainGray
    static let blackBackgroundColor: UIColor = ViewBackground.mainBlack
    static let snackbarBackgroundColor: UIColor = ViewBackground.snackbar
    static let tableViewBackgroundColor: UIColor = ViewBackground.tableView
    static let notificationCellBackgroundColor: UIColor = ViewBackground.notificationCell
    static let pickerBackgroundColor: UIColor = ViewBackground.picker
    static let instaStroeiesBackgroundColor: UIColor = ViewBackground.instaStroeies
    static let hasUnreadMessageCellBackground: UIColor = ViewBackground.hasUnreadMessageCell
    static let settingRootBackgroundColor: UIColor = ViewBackground.settingRoot
    static let separatorColor: UIColor = ViewBackground.separator
    static let borderColor: UIColor = ViewBackground.border
    static let veryLightPinkColor: UIColor = ViewBackground.mainGray
    static let badgeRedColor: UIColor = ViewBackground.badge
    static let twitterColor: UIColor = ViewBackground.twitter
    static let facebookColor: UIColor = ViewBackground.facebook
    static let lineColor: UIColor = ViewBackground.line
    static let attentionInfoColor: UIColor = UIColor.ViewBackground.attention
    static let rippleButtonBorderColor: UIColor = .ViewBackground.grayBorder
    //いずれ消す----ここまで

    enum Button {
        public static let gray: UIColor = .grayColor3
        public static let white: UIColor = .whiteColor1
        public static let black: UIColor = .blackColor1
        public static let blackDisable: UIColor = .grayColor3
        public static let hilighted: UIColor = .grayColor1
        public static let grayHilighted: UIColor = .grayColor5
    }
    //いずれ消す-----
    static let grayButtonBackgroundColor: UIColor = Button.gray
    static let navigationBackArrowButtonColor: UIColor = Button.gray
    static let navigationBackBlackArrowButtonColor: UIColor = Button.black
    static let blackButtonDisableBackgroundColor: UIColor = Button.blackDisable
    //いずれ消す----ここまで

    static let brownGrayColor: UIColor = .grayColor3
    static let barButtonItemNormalColor: UIColor = .blackColor1
    static let barButtonItemDisableColor: UIColor = .grayColor5
    static let filterShapeColor: UIColor = .grayColor5
    static let iconBorderColor: UIColor = .grayColor4
    static let selectBorderColor: UIColor = .blackColor1
    static let selectGreenBorderColor: UIColor = .greenColor2
    static let notificationBadgeColor: UIColor = .redColor1
    static let iconBlackColor: UIColor = .blackColor1
    static let iconWhiteColor: UIColor = .whiteColor1
    static let blackTranslucent: UIColor = .blackColor1.withAlphaComponent(0.6)
    static let salesTagColor: UIColor = .blackColor1.withAlphaComponent(0.8)
    static let grayRippleColor: UIColor = .grayColor1
    static let grayActiveRippleColor: UIColor = .grayColor1
    static let checkBoxOnBackgroundColor: UIColor = .greenColor1
    static let checkBoxAlertBackgroundColor: UIColor = .redColor1
    static let cancelTicketButtonColor: UIColor = .redColor1
    static let cancelTicketTextColor: UIColor = .whiteColor2
    static let secondaryTicketTextColor: UIColor = .blackColor3
    static let dashedLineTicketColor: UIColor = .blackColor4
    static let notificationBadgeGreenColor: UIColor = .greenColor1
    static let artistCellEmptyBackgroundColor: UIColor = .whiteColor3
    static let workDetailCellBorderColor: UIColor = .whiteColor3
    static let headerBackgroundColor: UIColor = .blackColor4
    static let messageTopBorderColor: UIColor = .grayColor4
    static let ashGreenColor: UIColor = .greenColor1
    static let cautionColor: UIColor = .redColor2
    static let bgDeleteCommentColor: UIColor = .redColor3
    static let bgReportCommentColor: UIColor = .blackColor2
    static let searchButtonHintTextColor: UIColor = .grayColor6
    static let followButtonColor: UIColor = .grayColor1
    static let selectGreenColor: UIColor = .greenColor2
    
    static let loginColor: UIColor = .redColor4
    
    static let placeholderColor: UIColor = .grayColor5
    static let privateEventIconBackgroundColor: UIColor = .whiteColor4
    static let profileIconBorderColor: UIColor = .grayColor4
    static let sendStickerCompletionBgGrayColor: UIColor = .blackColor4
    static let ticketDetailDashedLineColor: UIColor = .blackColor4
    static let hasMovieColor: UIColor = grayColor3.withAlphaComponent(0.3)
    static let comingSoonColor: UIColor = .grayColor3
    static let nowOpeningColor: UIColor = .redColor1
}

public extension UIImage {
    func with(color: UIColor?) -> UIImage? {
        guard let color else {
            return self
        }
        return UIGraphicsImageRenderer(size: self.size).image {[weak self] context in
            let rect = CGRect(origin: .zero, size: self!.size)
            
            // 元の画像を描画
            self!.draw(in: rect)
            
            // 色を描画
            context.cgContext.setBlendMode(.sourceAtop)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fill(rect)
        }
    }
}
public extension Optional<UIImage> {
    func with(color: UIColor?) -> UIImage? {
        if let self {
            self.with(color: color)
        } else {
            nil
        }
    }
}


#Preview {
    ButtonsViewController()
}
