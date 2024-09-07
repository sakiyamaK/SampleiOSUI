//
//  MyCollectionViewCell.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/07.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

import Kingfisher
import UIKit

final class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var icon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configureView()
    }

    private func configureView() {
        titleLabel.text = ""
        titleLabel.isHidden = true
        icon.image = nil
        icon.isHidden = true
    }

    @discardableResult
    func configure(sampleModel: SampleModel) -> Self {
        if let title = sampleModel.title, title.count > 0 {
            titleLabel.text = title
            titleLabel.isHidden = false
        }

        if let iconUrlStr = sampleModel.iconUrlStr,
           let iconUrl = URL(string: iconUrlStr)
        {
            icon.kf.setImage(with: iconUrl)
            icon.isHidden = false
        }

        // 値が決まってからlayoutをちゃんと更新する
        layoutIfNeeded()

        return self
    }
}

#Preview {
    UIViewController()
        .declarative {
            (MyCollectionViewCell.nib(bundle: .module).instantiate(withOwner: nil).first as! MyCollectionViewCell)
                .configure(sampleModel: .init(id: 10, title: "タイトル", iconUrlStr: nil))
                .center()
        }
}
