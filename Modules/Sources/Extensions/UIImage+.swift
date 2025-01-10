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

    func resize(_ size: CGFloat) -> UIImage {
        let resizedSize = {
            let imageW = self.size.width
            let imageH = self.size.height
            let scale = size / min(imageW, imageH)
            return CGSize(
                width: imageW * scale,
                height: imageH * scale
            )
        }()

        return UIGraphicsImageRenderer(
            size: resizedSize
        ).image { _ in
            draw(
                in: CGRect(
                    origin: .zero,
                    size: resizedSize
                )
            )
        }
    }

    func resize(to: CGSize) -> UIImage? {
        // aspect fill で指定サイズまでリサイズ
        let ratio = max(
            to.width / size.width,
            to.height / size.height
        )
        let resizedSize: CGSize = .init(
            width: Int(
                size.width * ratio
            ),
            height: Int(
                size.height * ratio
            )
        )
        return UIGraphicsImageRenderer(
            size: resizedSize
        ).image { context in
            draw(
                in: CGRect(
                    x: 0,
                    y: 0,
                    width: resizedSize.width,
                    height: resizedSize.height
                )
            )
        }
    }

    func iconify(diameter: CGFloat, padding: CGFloat, borderColor: UIColor = .clear) -> UIImage? {
        let size = CGSize(width: diameter, height: diameter)
        return UIGraphicsImageRenderer(size: size).image { context in

            // 元の画像をリサイズ
            guard let square = self.resize(
                to: CGSize(width: diameter - padding, height: diameter - padding)
            ) else { return }

            // クリッピングパスを作成して円形にする
            let path = UIBezierPath(
                arcCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                radius: size.width / 2,
                startAngle: 0,
                endAngle: .pi * 2,
                clockwise: true
            )
            path.addClip()

            // 画像を描画
            square.draw(in: CGRect(
                x: padding / 2,
                y: padding / 2,
                width: diameter - padding,
                height: diameter - padding
            ))

            // 円形の枠線を描画
            let circlePath = UIBezierPath(
                arcCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                radius: size.width / 2 - 0.5,
                startAngle: 0,
                endAngle: .pi * 2,
                clockwise: true
            )
            borderColor.setStroke()
            circlePath.lineWidth = 1
            circlePath.stroke()
        }
    }

    static func createPlaceholder(size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(
            size: size
        ).image { rendererContext in
            UIColor.placeholderColor
                .setFill()
            rendererContext.fill(
                CGRect(origin: .zero, size: size)
            )
        }
    }
}

public extension UIImage {
    func with(overlayColor: UIColor?) -> UIImage? {
        guard let overlayColor else {
            return self
        }
        return UIGraphicsImageRenderer(size: self.size).image {[weak self] context in
            let rect = CGRect(origin: .zero, size: self!.size)

            // 元の画像を描画
            self!.draw(in: rect)

            // 色を描画
            context.cgContext.setBlendMode(.sourceAtop)
            context.cgContext.setFillColor(overlayColor.cgColor)
            context.cgContext.fill(rect)
        }
    }
}
public extension Optional<UIImage> {
    func with(overlayColor: UIColor?) -> UIImage? {
        if let self {
            self.with(overlayColor: overlayColor)
        } else {
            nil
        }
    }
}
