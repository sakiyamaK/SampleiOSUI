import UIKit
import DeclarativeUIKit
import Extensions
import Components
import SwiftyAttributes
import RxSwift
import RxCocoa
import ObservableUIKit
import Files
import Toast

public class SampleViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
                
        self.applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UIScrollView.horizontal {
                UIStackView.horizontal {
                    (0...10).compactMap { _ in
                        UIStackView.horizontal {
                            UIView.spacer()
                                .width(20)
                            UIView.spacer()
                                .backgroundColor(.blue)
                            UIView.spacer()
                                .width(20)
                        }.width(UIScreen.main.bounds.width)
                    }
                }
            }
            .backgroundColor(.red)
            .isPagingEnabled(true)
            .height(UIScreen.main.bounds.width)
            .top()
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

public final class Sample2ViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.declarative {
            
            UIImageView()
                .contentMode(.center)
                .image(UIImage(named: "lufy", in: Bundle.module, compatibleWith: nil))
                .backgroundColor(.systemBlue)
//                .center()
//            UIButton(configuration: .plain().title("遷移"), primaryAction: .init(handler: {[weak self] _ in
//                let next = SampleViewController()
//                next.modalPresentationStyle = .fullScreen
//                self?.present(next, animated: true)
                
//            }))
//            .center()
        }.applyView { $0.backgroundColor = .white }
    }
}

#Preview {
    SampleViewController()
}
