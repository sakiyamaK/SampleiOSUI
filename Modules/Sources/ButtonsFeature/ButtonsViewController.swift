//
//  ButtonsViewController.swift
//  
//
//  Created by sakiyamaK on 2024/10/09.
//

import UIKit
import DeclarativeUIKit
import Extensions
import Components
import SwiftyAttributes
import ObservableUIKit
import Files

public class ButtonsViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UIStackView.vertical {
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
                
                UIButton(
                    configuration:
                            .plain()
                            .attributedTitle(
                                "作品購入で何かお困りですか？"
                                    .withFont(UIFont.defaultFontMedium(size: 12))
                            )
                            .baseForegroundColor(.systemGreen)
                            .contentInsets(.zero)
                ).configurationUpdateHandler({ button in
                        switch button.state {
                        case .highlighted:
                            button.configuration?.background = UIBackgroundConfiguration.clear()
                                .backgroundColor(.lightGray.withAlphaComponent(0.5))
                                .cornerRadius(8)
                        default:
                            button.configuration?.background = UIBackgroundConfiguration.clear()
                        }
                    }
                )
            }
            .spacing(20)
            .center()
        }
    }
}

public extension UIBackgroundConfiguration {
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor) -> Self {
        var _self = self
        _self.backgroundColor = backgroundColor
        return _self
    }
    
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        var _self = self
        _self.cornerRadius = cornerRadius
        return _self
    }
}

public extension UIButton.Configuration {
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

public extension UIButton {
    @discardableResult
    func configurationUpdateHandler(_ handler: UIButton.ConfigurationUpdateHandler?) -> Self {
        self.configurationUpdateHandler = handler
        return self
    }
}

#Preview {
    ButtonsViewController()
}
