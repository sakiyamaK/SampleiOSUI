//
//  MyCollectionViewCell3.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2022/07/02.
//  Copyright © 2022 sakiyamaK. All rights reserved.
//

import Kingfisher
import UIKit

final class MyCollectionViewCell3: UICollectionViewCell {
    private static var mockCell: MyCollectionViewCell3 = nib.instantiate(withOwner: self, options: nil).first as! MyCollectionViewCell3

    @IBOutlet private var icon: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        configureView()
    }

    private func configureView() {
        icon.image = nil
    }

    func configure(sampleModel: SampleModel) -> Self {
        if let iconUrlStr = sampleModel.iconUrlStr,
           let iconUrl = URL(string: iconUrlStr + "?id=\(sampleModel.id)")
        {
            icon.kf.setImage(with: iconUrl)
            icon.isHidden = false
        }

        // 値が決まってからlayoutをちゃんと更新する
        layoutIfNeeded()

        return self
    }

    static func calcSize(width: CGFloat, sampleModel: SampleModel, indexPath _: IndexPath = IndexPath(row: 0, section: 0)) -> CGSize {
        // まず横幅を大きめのwidthを指定して誓約に合わせてレイアウト更新する
        mockCell.bounds.size.width = width
        mockCell.contentView.bounds.size.width = width
        return mockCell.configure(sampleModel: sampleModel).systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
    }
}
