//
//  SwiftUICollectionViewCell1.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2021/11/03.
//  Copyright © 2021 sakiyamaK. All rights reserved.
//

import SwiftUI
import UIKit

/// HostingCellのContentになるViewが準拠するプロトコル
protocol HostingCellContent: View {
    associatedtype Dependency
    init(_ dependency: Dependency)
}

class HostingCell<Content: HostingCellContent>: UICollectionViewCell {
    private let hostingController = UIHostingController<Content?>(rootView: nil)

    override public init(frame: CGRect) {
        super.init(frame: frame)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(_ dependency: Content.Dependency, parent: UIViewController) {
        hostingController.rootView = Content(dependency)
        hostingController.view.invalidateIntrinsicContentSize()

        guard hostingController.parent == nil else { return }
        // 以下は初回のみ実行
        parent.addChild(hostingController)
        contentView.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
        ])
        hostingController.didMove(toParent: parent)
    }
}
