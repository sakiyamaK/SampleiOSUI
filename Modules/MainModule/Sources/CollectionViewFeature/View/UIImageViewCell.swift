//
//  UIImageViewCell.swift
//  SampleCompositonalLayout
//
//  Created by sakiyamaK on 2021/04/03.
//

import UIKit

final class UIImageViewCell: UICollectionViewCell {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.declarative {
            UIImageView(assign: &imageView)
        }

        contentView
            .clipsToBounds(true)
            .cornerRadius(0, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    @discardableResult
    func configure(sample: SampleImageModel, cornerRadius: CGFloat = 0) -> Self {
        imageView.image = sample.image
        contentView.cornerRadius(cornerRadius)
        return self
    }

    static private let mock: UIImageViewCell = .init(frame: .zero)
    static func calcSize(width: CGFloat, sample: SampleImageModel, cornerRadius: CGFloat = 0) -> CGSize {
        let targetSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        mock.frame.size = targetSize
        mock.prepareForReuse()
        return mock.configure(sample: sample, cornerRadius: cornerRadius).contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)

    }
}
