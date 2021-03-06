//
//  StackTableViewViewController.swift
//  __TARGET__
//
//  Created by  on 2021/3/16.
//

import UIKit

final class StackTableViewViewController: UIViewController {

    @IBOutlet private weak var stackView: UIStackView!

    static func makeFromStoryBoard() -> StackTableViewViewController {
        let vc = UIStoryboard(name: "StackTableView", bundle: nil).instantiateInitialViewController() as! StackTableViewViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for sample in SampleModel.samples {
            let cell =  SampleTableViewCell.makeFromSXib()
            cell.configure(sample: sample)
            cell.delegate = self
            stackView.addArrangedSubview(cell)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let cell = self.stackView.arrangedSubviews[3] as! SampleTableViewCell
            let model = SampleModel(name: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", description:
                                        """
aa\n
aa\n
aa\n
aa\n
aa\n
aa\n
aa\n
aa\n
aa
"""
            )
            cell.configure(sample: model)
            UIView.animate(withDuration: 0.3) {
                self.stackView.layoutIfNeeded()
            }
        }
    }
}

extension StackTableViewViewController: SampleTableViewCellProtocol {
    func select(sample: SampleModel) {
        print(sample.name)
        print(sample.description)
    }
}
