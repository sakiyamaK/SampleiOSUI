import UIKit
import DeclarativeUIKit
import Extensions
import Components
import SwiftyAttributes
import RxSwift
import RxCocoa
import ObservableUIKit
import Files

public class SampleViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UIButton(
                configuration:
                        .filled()
                        .attributedTitle(
                            "hogee".withFont(UIFont.defaultFontBold(size: 40))
                        )
                        .baseBackgroundColor(.blackColor1)
                        .baseForegroundColor(.grayColor1)
                        .cornerStyle(.capsule)
            )
                .center()
        }
    }
}

extension UIButton.Configuration {
    @discardableResult
    func attributedTitle(_ attributedTitle: NSMutableAttributedString?) -> Self {
        guard let attributedTitle else { return self }
        var _self = self
        let nsAttributedString = NSAttributedString(attributedString: attributedTitle)
        let attributedString = AttributedString(nsAttributedString)
        _self.attributedTitle = attributedString
        return _self
    }
}

#Preview {
    SampleViewController()
}
