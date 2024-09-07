//
//  MyCollectionViewCell2.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/07.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

import Kingfisher
import UIKit

final class MyCollectionViewCell2: UICollectionViewCell {
    private static var mockCell: MyCollectionViewCell2 = MyCollectionViewCell2.makeFormNibFirst(bundle: .module)!

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var icon: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        configureView()
    }

    private func configureView() {
        titleLabel.text = nil
        titleLabel.isHidden = true
        icon.image = nil
        icon.isHidden = true
        descriptionLabel.text = nil
        descriptionLabel.isHidden = true
    }

    @discardableResult
    func configure(sampleModel: SampleModel) -> Self {
        if let title = sampleModel.title, title.count > 0 {
            titleLabel.text = title
            titleLabel.isHidden = false
        }

        if let iconUrlStr = sampleModel.iconUrlStr,
           let iconUrl = URL(string: iconUrlStr + "?id=\(sampleModel.id)")
        {
            icon.kf.setImage(with: iconUrl)
            icon.isHidden = false
        }

        if let description = sampleModel.description,
           !description.isEmpty
        {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        }

        // 値が決まってからlayoutをちゃんと更新する
        layoutIfNeeded()

        return self
    }

    static func calcSize(width: CGFloat, sampleModel: SampleModel, indexPath: IndexPath = IndexPath(row: 0, section: 0)) -> CGSize {
        // まず横幅を大きめのwidthを指定して誓約に合わせてレイアウト更新する
        mockCell.bounds.size.width = width
        mockCell.contentView.bounds.size.width = width
        mockCell.configure(sampleModel: sampleModel)

        // パラメータに合わせてサイズを求める
        let size = mockCell.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        //    let size = mockCell.systemLayoutSizeFitting(
        //      UIView.layoutFittingCompressedSize,
        //      withHorizontalFittingPriority: .required,
        //      verticalFittingPriority: .fittingSizeLevel
        //    )

        // 得られたサイズを返す
        return size
    }
}

#Preview {
    UIViewController()
        .declarative {
            MyCollectionViewCell2.makeFormNibFirst(bundle: .module)!
                .configure(sampleModel: .init(id: 10, title: "タイトル", iconUrlStr: nil))
                .center()
        }
}
