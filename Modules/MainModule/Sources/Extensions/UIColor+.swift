//
//  File.swift
//  
//
//  Created by sakiyamaK on 2023/03/08.
//

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
    
    // 四角の画像にする
    func rectImage(width: CGFloat, height: CGFloat, margin: UIEdgeInsets = .zero) -> UIImage {
        let rect = CGRect(x: margin.left, y: margin.top, width: width, height: height)
        let size = CGSize(width: width + margin.left + margin.right, height: height + margin.top + margin.bottom)
        UIGraphicsBeginImageContext(size)
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.setFillColor(self.cgColor)
        contextRef?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
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
    static let blackColor1: UIColor = .init(hex: 0x000000)
    static let redColor1: UIColor = .init(hex: 0xff4f59)
    static let greenColor1: UIColor = .init(hex: 0x13857c)
    static let yellowColor1: UIColor = .init(hex: 0xF0E600)
    static let whiteColor1: UIColor = .init(hex: 0xffffff)
    
    static let mainTextColor: UIColor = .blackColor1
    static let subTextColor: UIColor = .grayColor3
    static let mainWhiteTextColor: UIColor = .whiteColor1
    static let barButtonItemNormalColor: UIColor = .blackColor1
    static let barButtonItemDisableColor: UIColor = .grayColor5
    static let navigationBackArrowButtonColor: UIColor = .grayColor3
    static let navigationBackBlackArrowButtonColor: UIColor = .blackColor1
    static let iconBorderColor: UIColor = .grayColor4
    static let grayBackgroundColor: UIColor = .grayColor4
    static let settingRootBackgroundColor: UIColor = .grayBackgroundColor
    static let blackBackgroundColor: UIColor = .blackColor1
    static let borderColor: UIColor = .grayColor1
    static let separatorColor: UIColor = .grayColor2
    static let cancelTicketButtonColor: UIColor = .redColor1
    static let notificationBadgeColor: UIColor = .redColor1
    static let attentionInfoColor: UIColor = .redColor1
    static let textLinkColor: UIColor = .greenColor1
    static let iconBadgeColor: UIColor = .greenColor1
    static let iconBlackColor: UIColor = .blackColor1
    static let iconWhiteColor: UIColor = .whiteColor1
    static let blackTranslucent: UIColor = .blackColor1.withAlphaComponent(0.6)
    static let textWhiteColor: UIColor = .whiteColor1
    static let salesTagColor: UIColor = .blackColor1.withAlphaComponent(0.8)
    static let mainViewBackgroundColor: UIColor = .whiteColor1
}
