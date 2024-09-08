//import UIKit
//
//public class ExpandableLabel: UILabel {
//    private let seeMoreText = "...続きを見る"
//    private var originalText: String?
//    private var isExpanded = false
//    private var tapGesture: UITapGestureRecognizer!
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    private func setup() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(updateText),
//                                               name: Notification.Name.injection, object: nil)
//        numberOfLines = 6
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        addGestureRecognizer(tapGesture)
//        isUserInteractionEnabled = true
//    }
//
//    public override var text: String? {
//        didSet {
//            if !isExpanded {
//                updateText()
//            }
//        }
//    }
//
//    @objc private func updateText() {
//        guard let fullText = text else { return }
//        originalText = fullText
//        print(fullText)
//        print(numberOfLines)
//        let range = NSRange(location: 0, length: fullText.count)
//        let storage = NSTextStorage(string: fullText)
//        let layoutManager = NSLayoutManager()
//        storage.addLayoutManager(layoutManager)
//        let lineHeight = font.lineHeight
//        let maxHeight = lineHeight * CGFloat(numberOfLines)
//        let containerSize = CGSize(width: frame.width, height: maxHeight)
//        let textContainer = NSTextContainer(size: containerSize)
//        textContainer.exclusionPaths = [.init(rect: .init(x: 20, y: 20, width: 10, height: 10)) ]
//        layoutManager.addTextContainer(textContainer)
//        let seeMoreRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
//
//        guard NSLocationInRange(seeMoreRange.location, range) else {
//            return
//        }
//
//        let visibleRange = layoutManager.glyphRange(for: textContainer)
//        let visibleText = (fullText as NSString).substring(with: visibleRange)
//        let displayText = "\(visibleText)\(seeMoreText)"
//        let attributedText = NSMutableAttributedString(string: displayText)
//        let seeMoreTextColor = UIColor.blue
//        let seeMoreAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: seeMoreTextColor
//        ]
//        attributedText.addAttributes(seeMoreAttributes, range: NSRange(location: visibleRange.length, length: seeMoreText.count))
//        print(attributedText)
//        self.attributedText = attributedText
//    }
//
//    @objc private func handleTap(sender: UITapGestureRecognizer) {
//        let tapLocation = sender.location(in: self)
//        let layoutManager = NSLayoutManager()
//        let textContainer = NSTextContainer(size: CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
//        let textStorage = NSTextStorage(attributedString: attributedText!)
//        layoutManager.addTextContainer(textContainer)
//        textStorage.addLayoutManager(layoutManager)
//        let characterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//        if let originalText = originalText, characterIndex >= originalText.count {
//            isExpanded = true
//            self.text = originalText
//            numberOfLines = 0
//            removeGestureRecognizer(tapGesture)
//        }
//    }
//}
