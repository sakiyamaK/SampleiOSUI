//
//  StoppableCollectionHeaderView.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2021/10/21.
//  Copyright © 2021 sakiyamaK. All rights reserved.
//

import UIKit

final class StoppableCollectionHeaderView: UICollectionReusableView {
    let stoppableContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stoppableContainerView)
        stoppableContainerView.translatesAutoresizingMaskIntoConstraints = false
        let dmmyHeightConst = stoppableContainerView.heightAnchor.constraint(equalToConstant: 0)
        dmmyHeightConst.priority = .init(rawValue: 1)
        let constraints: [NSLayoutConstraint] = [
            stoppableContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: stoppableContainerView.trailingAnchor),
            bottomAnchor.constraint(equalTo: stoppableContainerView.bottomAnchor),
            dmmyHeightConst,
        ]

        NSLayoutConstraint.activate(constraints)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        print("\(#function)")
    }

    func configure(stoppableView: UIView, viewController: UIViewController) {
        if !stoppableContainerView.subviews.contains(where: { $0 == stoppableView }) {
            print("\(#function) add")
            viewController.view.addSubview(stoppableView)
            stoppableView.translatesAutoresizingMaskIntoConstraints = false

            let yConst = stoppableView.centerYAnchor.constraint(equalTo: stoppableContainerView.centerYAnchor)
            yConst.priority = .init(rawValue: 1)
            let constraints: [NSLayoutConstraint] = [
                stoppableView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
                stoppableView.topAnchor.constraint(greaterThanOrEqualTo: viewController.view.safeAreaLayoutGuide.topAnchor),
                stoppableContainerView.heightAnchor.constraint(equalTo: stoppableView.heightAnchor),
                yConst,
            ]

            NSLayoutConstraint.activate(constraints)
        }
        print("\(#function)")
        backgroundColor = .red
    }
}
