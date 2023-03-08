//
//  UICollectionHeaderView01.swift
//  SampleCompositonalLayout
//
//  Created by sakiyamaK on 2021/03/21.
//

import DeclarativeUIKit
import UIKit

final class UICollectionHeaderView01: UICollectionReusableView {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private weak var textLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBlue

        declarative {
            UIStackView.vertical {
                UILabel(assign: &textLabel)
                    .contentHuggingPriority(.required, for: .vertical)
                    .contentCompressionResistancePriority(.required, for: .vertical)
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }

    @discardableResult
    func configure(indexPath: IndexPath) -> Self {
        textLabel.text = "section header : " + indexPath.section.description
        return self
    }

    @discardableResult
    func configure(text: String) -> Self {
        textLabel.text = text
        return self
    }
}
