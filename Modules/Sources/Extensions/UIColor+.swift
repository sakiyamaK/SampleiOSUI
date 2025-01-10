// Copyright © The Chain Museum. All rights reserved.

import UIKit

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
        public static let caution: UIColor = .redColor1
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
        public static let pageIndicatorTintColor = UIColor.grayColor7
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
    static let messageTopBorderColor: UIColor = .ViewBackground.mainGray

    //いずれ消す----ここまで

    enum Button {
        public static let gray: UIColor = .grayColor3
        public static let white: UIColor = .whiteColor1
        public static let black: UIColor = .blackColor1
        public static let blackDisable: UIColor = .grayColor3
        public static let hilighted: UIColor = .grayColor1
        public static let grayHilighted: UIColor = .grayColor5
        public static let caution: UIColor = .redColor3
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

import SwiftUI

public extension UIColor {
    var color: Color {
        Color(self)
    }
}
