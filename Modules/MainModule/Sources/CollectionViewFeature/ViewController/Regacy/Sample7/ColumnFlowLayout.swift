//
//  ColumnFlowLayout.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2021/10/18.
//  Copyright © 2021 sakiyamaK. All rights reserved.
//

import UIKit

final class ColumnFlowLayout: UICollectionViewFlowLayout {
    enum LayoutType {
        case type0, type1
    }

    var layoutType = LayoutType.type0
    override func prepare() {
        super.prepare()

        guard let cv = collectionView else { return }

        let cellWidth: CGFloat
        switch layoutType {
        case .type0:
            cellWidth = cv.bounds.inset(by: cv.layoutMargins).width
        case .type1:
            let availableWidth = cv.bounds.inset(by: cv.layoutMargins).width
            let minColumnWidth = CGFloat(300)
            let maxNumColumns = Int(availableWidth / minColumnWidth)
            cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        }

        itemSize = .init(width: cellWidth, height: 70)
        sectionInset = .init(top: minimumInteritemSpacing, left: 0, bottom: 0, right: 0)
        sectionInsetReference = .fromSafeArea
    }
}
