//
//  UICollectionViewCell01.swift
//  SampleCompositonalLayout
//
//  Created by sakiyamaK on 2021/03/21.
//

import UIKit

final class UICollectionViewCell01: UICollectionViewCell {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
        }
    }

    private weak var textLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.declarative {
            UIStackView.vertical {
                UILabel(assign: &textLabel)
                    .contentHuggingPriority(.required, for: .vertical)
                    .contentCompressionResistancePriority(.required, for: .vertical)
            }
            .alignment(.center)
        }

        contentView
            .clipsToBounds(true)
            .cornerRadius(0, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }

    @discardableResult
    func configure(sample: SampleModel02, cornerRadius: CGFloat = 0, backgroundColor: UIColor = .white) -> Self {
        contentView.backgroundColor = backgroundColor
        textLabel.text = sample.text
        self.cornerRadius = cornerRadius
        return self
    }
}

#Preview {
    UIViewController()
        .declarative {
            UICollectionViewCell01()
                .configure(sample: .init(text: "hoge"))
                .center()
        }
}
