//
//  UIImage+.swift
//  
//
//  Created by sakiyamaK on 2024/04/28.
//

import UIKit

public extension UIImage {
    func resizeIf(longLength: CGFloat) -> UIImage {
        if max(size.width, size.height) > longLength {
            resize(longLength: longLength)
        } else {
            self
        }
    }
    
    func resize(longLength: CGFloat) -> UIImage {
        let aspectRatio = size.width / size.height
        let newSize: CGSize = if size.width > size.height {
            .init(width: longLength, height: longLength / aspectRatio)
        } else {
            .init(width: longLength * aspectRatio, height: longLength)
        }
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
