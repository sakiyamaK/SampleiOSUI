//
//  UIFont+.swift
//  
//
//  Created by sakiyamaK on 2023/03/08.
//

import UIKit

public extension UIFont {
    
    static func safeNotoSansCJKjpBold(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .bold)
    }
    
    static func safeNotoSansCJKjpLight(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .light)
    }
    
    static func safeNotoSansCJKjpMedium(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .medium)
    }
    
    static func safeNotoSansCJKjpRegular(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .regular)
    }
}

public extension UIFont {
    
    static func defaultFontLight(size: CGFloat) -> UIFont {
        .safeNotoSansCJKjpLight(size: size)
    }
    
    static func defaultFontRegular(size: CGFloat) -> UIFont {
        .safeNotoSansCJKjpRegular(size: size)
    }
    
    static func defaultFontMedium(size: CGFloat) -> UIFont {
        .safeNotoSansCJKjpMedium(size: size)
    }
    
    static func defaultFontBold(size: CGFloat) -> UIFont {
        .safeNotoSansCJKjpBold(size: size)
    }
}
