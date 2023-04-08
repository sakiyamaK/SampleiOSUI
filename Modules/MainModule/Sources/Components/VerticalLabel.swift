//
//  VerticalLabel.swift
//  
//
//  Created by sakiyamaK on 2023/03/28.
//

import UIKit

public final class VerticalLabel: UILabel {
    public override func draw(_ rect: CGRect) {
        guard let text = self.text,
            let context = UIGraphicsGetCurrentContext(),
            let textStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle else { return }

        let transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        context.concatenate(transform)
        context.translateBy(x: -rect.size.height, y: 0)
        var newRect = rect.applying(transform)
        newRect.origin = CGPoint.zero

        textStyle.lineBreakMode = self.lineBreakMode
        textStyle.alignment = self.textAlignment

        let attributeDict: [NSAttributedString.Key: AnyObject] = [.font: self.font, .foregroundColor: self.textColor, .paragraphStyle: textStyle]

        let nsStr = text as NSString
        nsStr.draw(in: newRect, withAttributes: attributeDict)

    }
}
