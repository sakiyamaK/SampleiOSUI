//
//  UIFont+.swift
//  
//
//  Created by sakiyamaK on 2023/03/08.
//

import UIKit

public extension UIFont {
    
    /// `UIFont(name: "NotoSansCJKjp-Bold", size: ...)`
    static func safeNotoSansCJKjpBold(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size)
    }
    
    /// `UIFont(name: "NotoSansCJKjp-Light", size: ...)`
    static func safeNotoSansCJKjpLight(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size)
    }
    
    /// `UIFont(name: "NotoSansCJKjp-Medium", size: ...)`
    static func safeNotoSansCJKjpMedium(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size)
    }
    
    /// `UIFont(name: "NotoSansCJKjp-Regular", size: ...)`
    static func safeNotoSansCJKjpRegular(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size)
    }
    
    /// `UIFont(name: "NB-Akademie-Medium", size: ...)`
    static func safeNbAkademieMedium(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size)
    }
}

public extension UIFont {
    
    static func defaultFontLight(size: CGFloat) -> UIFont {
        return self.safeNotoSansCJKjpLight(size: size)
    }
    
    static func defaultFontRegular(size: CGFloat) -> UIFont {
        return self.safeNotoSansCJKjpRegular(size: size)
    }
    
    static func defaultFontMedium(size: CGFloat) -> UIFont {
        return self.safeNotoSansCJKjpMedium(size: size)
    }
    
    static func defaultFontBold(size: CGFloat) -> UIFont {
        return self.safeNotoSansCJKjpBold(size: size)
    }
}
