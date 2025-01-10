//
//  File.swift
//  
//
//  Created by sakiyamaK on 2023/04/09.
//

import UIKit
import DeclarativeUIKit
import Extensions
import Components


//public class VerticalTextView: UITextView {
//
//    public override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
////        self.transform = CGAffineTransform(rotationAngle: Double.pi / 2)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//   public override func draw(_ rect: CGRect) {
//       let context = UIGraphicsGetCurrentContext()
//       context?.scaleBy(x: 1.0, y: 1.0)
//       super.draw(rect)
//   }
//
//    public func configureTextView() {
//        let verticalText = NSMutableAttributedString(attributedString: attributedText)
//        let fullRange = NSRange(location: 0, length: verticalText.length)
//
////        verticalText.addAttribute(.verticalGlyphForm, value: NSNumber(value: true), range: fullRange)
//        verticalText.addAttribute(.writingDirection, value: [NSWritingDirection.rightToLeft.rawValue | NSWritingDirectionFormatType.override.rawValue], range: fullRange)
//        attributedText = verticalText
//    }
//}

//public class VerticalTextContainer: NSTextContainer {
//
//    public override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
//        remainingRect?.pointee = .zero
//        return CGRect(x: 0, y: proposedRect.origin.y, width: self.size.height, height: proposedRect.size.height)
//    }
//}
//
//public class VerticalTextView: UIView {
//
//    var layoutManager: NSLayoutManager?
//
//    override public func draw(_ rect: CGRect) {
//        guard let layoutManager, let context = UIGraphicsGetCurrentContext() else {
//            super.draw(rect)
//            return
//        }
//
//        layoutManager.enumerateLineFragments(forGlyphRange: .init(location: 0, length: layoutManager.numberOfGlyphs)) { lineRect, usedRect, textContainer, glyphRange, stop in
//
//            context.saveGState()
//
//            // Lay the text vertically, reading top-left to bottom-right
//            context.scaleBy(x: -1, y: 1)
//            context.rotate(by: Double.pi/2.0)
//            // Flip text line fragment along X axis
//            context.translateBy(x: 0, y: lineRect.origin.y)
//            context.scaleBy(x: 1, y: -1)
//            context.translateBy(x: 0, y: -(lineRect.origin.y + lineRect.size.height))
//
//            // Draw the line fragment
//            layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: .zero)
//
//            context.restoreGState()
//        }
//    }
//}


public class VerticalTextViewController: UIViewController {
    
    private weak var textView: UITextView!
//    private weak var verticalTextView: VerticalTextView!
    
    public override func loadView() {
        super.loadView()
        
        // ホットリロードさせるメソッドを設定
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_viewDidLoad),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        _viewDidLoad()
    }
}

@objc private extension VerticalTextViewController {
    
    func _viewDidLoad() {
//        let container = VerticalTextContainer(size: verticalTextView.bounds.size)
//        let layoutManager = NSLayoutManager()
//        layoutManager.addTextContainer(container)
//        layoutManager.textStorage = textView.textStorage
//        verticalTextView.layoutManager = layoutManager
    }
    
    func setupLayout() {
        self.view.backgroundColor = .white
        
        self.declarative {
            UITextView(assign: &self.textView)
                .text(SampleTextContents.sample02)
                .font(UIFont.defaultFontRegular(size: 20))
                .isDirectionalLockEnabled(true)
                .isScrollEnabled(true)
                .apply {
                    $0.textContainerInset = .zero
                }
//                .transform(.init(rotationAngle: Double.pi/2.0))
        }
        
        textView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true

//        self.declarative(reset: false) {
//            VerticalTextView(assign: &self.verticalTextView)
//                .backgroundColor(.white)
//        }
    }
}

#Preview {
    VerticalTextViewController()
}
