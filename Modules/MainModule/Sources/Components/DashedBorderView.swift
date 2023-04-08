//
//  DashedBorderView.swift
//  
//
//  Created by sakiyamaK on 2023/04/08.
//

import UIKit

public final class DashedBorderView: UIView {
    
    public struct DashBorderParameter {
        var dashPattern: [NSNumber] = []
        var lineWidth: CGFloat = 0
        var lineColor: UIColor = .blackColor1
        var cornerRadiusDivisionPerHeight: CGFloat = 2
        var cornerRadiusDivisionPerHeightNotZero: CGFloat {
            guard cornerRadiusDivisionPerHeight > 0 else { return 1 }
            return cornerRadiusDivisionPerHeight
        }
    }
    
    var dashBorderParameter: DashBorderParameter?
    
    public convenience init(dashBorderParameter: DashBorderParameter? = nil) {
        self.init(frame: .zero)
        self.dashBorderParameter = dashBorderParameter
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let dashBorderParameter else { return }

        let dashedLayer = CAShapeLayer()
        dashedLayer.path = UIBezierPath(
            roundedRect: rect.insetBy(dx: 1, dy: 1),
            cornerRadius: frame.size.height / dashBorderParameter.cornerRadiusDivisionPerHeightNotZero
        ).cgPath
        dashedLayer.fillColor = UIColor.clear.cgColor
        dashedLayer.strokeColor = dashBorderParameter.lineColor.cgColor
        dashedLayer.lineWidth = dashBorderParameter.lineWidth
        dashedLayer.lineDashPattern = dashBorderParameter.dashPattern
        layer.addSublayer(dashedLayer)
    }
}
