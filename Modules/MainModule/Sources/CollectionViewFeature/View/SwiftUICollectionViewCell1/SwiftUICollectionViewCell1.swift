//
//  SwiftUICollectionViewCell1.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2021/11/03.
//  Copyright © 2021 sakiyamaK. All rights reserved.
//

import SwiftUI
import UIKit

final class SwiftUICollectionViewCell1: HostingCell<SwiftUICollectionViewCell1View> {
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = false
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = .init(width: 0, height: 2)
        layer.shadowRadius = 3

        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 16
    }
}
