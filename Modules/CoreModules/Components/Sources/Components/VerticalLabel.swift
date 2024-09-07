////
////  VerticalLabel.swift
////  
////
////  Created by sakiyamaK on 2023/03/28.
////
//
//import UIKit
////
////public class VerticalLabel: UIView {
////    private let textLayer = CATextLayer()
////    
////    public var text: String? {
////        didSet {
////            updateTextLayer()
////        }
////    }
////    
////    public var font: UIFont = UIFont.systemFont(ofSize: 17) {
////        didSet {
////            updateTextLayer()
////        }
////    }
////    
////    public var textColor: UIColor = .black {
////        didSet {
////            updateTextLayer()
////        }
////    }
////    
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        setupTextLayer()
////    }
////    
////    required init?(coder: NSCoder) {
////        super.init(coder: coder)
////        setupTextLayer()
////    }
////    
////    private func setupTextLayer() {
////        textLayer.contentsScale = UIScreen.main.scale
////        textLayer.isWrapped = true
////        textLayer.alignmentMode = .center
////        layer.addSublayer(textLayer)
////        updateTextLayer()
////    }
////    
////    private func updateTextLayer() {
////        textLayer.font = font
////        textLayer.fontSize = font.pointSize
////        textLayer.foregroundColor = textColor.cgColor
////        textLayer.string = text
////        setNeedsLayout()
////    }
////    
////    public override func layoutSubviews() {
////        super.layoutSubviews()
////        
////        let transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
////        textLayer.frame = bounds
////        textLayer.setAffineTransform(transform)
////    }
////}
//
//public final class VerticalLabel: UILabel {
//    public override func draw(_ rect: CGRect) {
//        guard let text = self.text,
//            let context = UIGraphicsGetCurrentContext(),
//            let textStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle else { return }
//
//        let transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
//        context.concatenate(transform)
//        context.translateBy(x: -rect.size.height, y: 0)
//        var newRect = rect.applying(transform)
//        newRect.origin = CGPoint.zero
//
//        textStyle.lineBreakMode = self.lineBreakMode
//        textStyle.alignment = self.textAlignment
//
//        let attributeDict: [NSAttributedString.Key: AnyObject] = [.font: self.font, .foregroundColor: self.textColor, .paragraphStyle: textStyle]
//
//        let nsStr = text as NSString
//        nsStr.draw(in: newRect, withAttributes: attributeDict)
//
//    }
//}
//
//
//#Preview {
//    UIViewController()
//        .declarative {
//            VerticalLabel()
//                .apply({
//                    $0.text = "縦置き"
//                })
//                .top()
//                .right()
//        }
//}
