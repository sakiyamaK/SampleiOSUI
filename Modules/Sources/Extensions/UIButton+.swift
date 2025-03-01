// Copyright © The Chain Museum. All rights reserved.

import UIKit
import DeclarativeUIKit
import SwiftyAttributes

// - capsule
public extension UIButton.Configuration {

    static func capsule(
        title: String,
        titleColor: UIColor = .Text.main,
        font: UIFont = .defaultFontMedium(size: 14),
        strokeColor: UIColor = .ViewBackground.whiteBorder,
        image: UIImage? = nil,
        imagePadding: CGFloat = 12,
        backgroundColor: UIColor = .ViewBackground.main,
        contentInsets: NSDirectionalEdgeInsets = .init(horizontal: 16)
    ) -> UIButton.Configuration {
        .borderedProminent()
        .cornerStyle(.capsule)
        .attributedTitle(title.withFont(font))
        .image(image)
        .imagePadding(imagePadding)
        .background(.clear().strokeColor(strokeColor).strokeWidth(1))
        .baseBackgroundColor(backgroundColor)
        .baseForegroundColor(titleColor)
        .contentInsets(contentInsets)
    }
}

public extension UIButton {

    @discardableResult
    func capsuleButtonBackgroundColors(
        default defaultColor: UIColor = .ViewBackground.main,
        highlighted hilightedColor: UIColor = .Button.hilighted,
        disabled disabledColor: UIColor? = nil,
        defaultStroke defaultStrokeColor: UIColor = .ViewBackground.main,
        highlightedStroke highlightedStrokeColor: UIColor = .Button.hilighted,
        disabledStroke disabledStrokeColor: UIColor? = nil
    ) -> Self {
        guard let background = configuration?.background else {
            return self
        }

        self.configurationUpdateHandler({ button in
            switch button.state {
            case .highlighted:
                button.configuration?.background = background
                    .backgroundColor(
                        hilightedColor
                    ).strokeColor(
                        highlightedStrokeColor
                    )
            case .disabled:
                button.configuration?.background = background
                    .backgroundColor(
                        disabledColor ?? defaultColor.withAlphaComponent(0.2)
                    ).strokeColor(
                        disabledStrokeColor ?? defaultStrokeColor.withAlphaComponent(0.2)
                    )
            default:
                button.configuration?.background = background
                    .backgroundColor(
                        defaultColor
                    ).strokeColor(
                        defaultStrokeColor
                    )
            }
        })
        return self
    }
}

// - image
public extension UIButton.Configuration {

    static func image(
        icon: UIImage? = nil,
        iconSize: CGFloat,
        backgroundColor: UIColor = .ViewBackground.clear,
        contentInsets: NSDirectionalEdgeInsets = .zero
    ) -> UIButton.Configuration {
        .plain()
        .image(icon)
        .preferredSymbolConfigurationForImage(.init(pointSize: iconSize))
        .baseBackgroundColor(backgroundColor)
        .contentInsets(contentInsets)
    }

}

public extension UIButton {

    @discardableResult
    func imageButtonBackgroundColors(
        image: UIImage?,
        default defaultColor: UIColor = .ViewBackground.clear,
        highlighted hilightedColor: UIColor? = .Button.hilighted
    ) -> Self {
        self.configurationUpdateHandler({ button in
            let color = switch button.state {
            case .highlighted:
                hilightedColor
            default:
                defaultColor
            }
            // withTintColorでは半透明ができない
            button.configuration?.image = image.with(overlayColor: color?.withAlphaComponent(
                color != .clear ? 0.5 : 0.0
            ))
            button.configuration?.background = .clear().backgroundColor(color)
        })
        return self
    }
}

// - plane
public extension UIButton {

    @discardableResult
    func planBackgroundColors(
        default defaultColor: UIColor = .Button.white,
        highlighted hilightedColor: UIColor? = .Button.hilighted,
        cornerRadius: CGFloat = 0
    ) -> Self {
        self.configurationUpdateHandler({ button in
            button.configuration?.background = switch button.state {
            case .highlighted:
                UIBackgroundConfiguration.clear()
                    .backgroundColor(hilightedColor)
                    .cornerRadius(cornerRadius)
            default:
                UIBackgroundConfiguration.clear()
                    .backgroundColor(defaultColor)
                    .cornerRadius(cornerRadius)
            }
        })
        return self
    }
}

// - text
public extension UIButton.Configuration {

    static func text(
        title: String,
        titleColor: UIColor = .Text.main,
        font: UIFont = .defaultFontMedium(size: 14),
        backgroundColor: UIColor = .ViewBackground.clear,
        contentInsets: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    ) -> UIButton.Configuration {
        .borderedProminent()
        .attributedTitle(title.withFont(font))
        .baseForegroundColor(titleColor)
        .baseBackgroundColor(backgroundColor)
        .contentInsets(contentInsets)
    }

    static func text(
        title: NSAttributedString,
        titleColor: UIColor = .Text.main,
        backgroundColor: UIColor = .ViewBackground.clear,
        contentInsets: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    ) -> UIButton.Configuration {
        .borderedProminent()
        .attributedTitle(title)
        .baseForegroundColor(titleColor)
        .baseBackgroundColor(backgroundColor)
        .contentInsets(contentInsets)
    }

}

public extension UIButton {

    @discardableResult
    func textBackgroundColors(
        default defaultColor: UIColor = .Button.white,
        highlighted hilightedColor: UIColor? = .Button.hilighted,
        cornerRadius: CGFloat = 0
    ) -> Self {
        self.planBackgroundColors(
            default: defaultColor,
            highlighted: hilightedColor,
            cornerRadius: cornerRadius
        )
    }
}

// MARK: - storke
public extension UIButton.Configuration {
    static func storkeButtonConfiguration(title: String, buttonSize: Size = .large) -> UIButton.Configuration {
        UIButton.Configuration.filled()
            .title(title)
            .baseBackgroundColor(.ViewBackground.main)
            .baseForegroundColor(.Text.main)
            .cornerStyle(.capsule)
            .buttonSize(buttonSize)
            .background(
                UIBackgroundConfiguration
                    .clear()
                    .strokeColor(.ViewBackground.border)
                    .strokeWidth(1.0)
            )
    }
}

public extension UIButton {
    func strokeBackgroundColors(
        default defaultColor: UIColor = .Button.white,
        highlighted hilightedColor: UIColor? = .Button.hilighted
    ) -> Self {
        self.configurationUpdateHandler({ button in
            guard let nowBackground = button.configuration?.background else {
                return
            }
            button.configuration?.background = switch button.state {
            case .highlighted:
                nowBackground
                    .backgroundColor(hilightedColor)
            default:
                nowBackground
                    .backgroundColor(defaultColor)
            }
        })
        return self
    }

}
