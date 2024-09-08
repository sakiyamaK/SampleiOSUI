//
//  UICollectionViewCell02.swift
//  SampleCompositonalLayout
//
//  Created by sakiyamaK on 2021/10/01.
//

import UIKit

final class CollectionViewCell02: UICollectionViewCell {
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var timeAgoLabel: UILabel!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var mainTextLabel: UILabel!
    @IBOutlet private var mainImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        iconView.isHidden = true
        nameLabel.text = nil
        nameLabel.isHidden = true
        timeAgoLabel.text = nil
        timeAgoLabel.isHidden = true
        userNameLabel.text = nil
        userNameLabel.isHidden = true
        mainTextLabel.text = nil
        mainTextLabel.isHidden = true
        mainImageView.image = nil
        mainImageView.isHidden = true
    }

    func configure() {}
}
