//
//  SampleTableViewCell.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2021/03/16.
//

import UIKit

protocol SampleTableViewCellProtocol: AnyObject {
    func select(sample: SampleModel)
}

final class SampleTableViewCell: UITableViewCell {

    static func makeFromSXib() -> SampleTableViewCell {
        let view = UINib(nibName: "SampleTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil) as! SampleTableViewCell
        return view
    }

    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    weak var delegate: SampleTableViewCellProtocol?

    private var sample: SampleModel!

    func configure(sample: SampleModel) {
        mainLabel.text = sample.name
        descriptionLabel.text = sample.description
        self.sample = sample

        let g = UITapGestureRecognizer.init(target: self, action: #selector(self.tapCell))
        self.contentView.addGestureRecognizer(g)
    }

    @objc private func tapCell() {
        self.delegate?.select(sample: self.sample)
    }
}
