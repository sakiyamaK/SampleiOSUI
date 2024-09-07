//
//  UICollectionView+.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/07/25.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func adaptBeautifulGrid(numberOfGridsSubAxis: Int = 1,
                            gridLineSpace space: CGFloat = 0,
                            sectionInset inset: UIEdgeInsets = .zero,
                            size: CGSize = .zero,
                            lengthMainAxis: ScrollDirection = .vertical,
                            multiplierLengthSubAxis: CGFloat = 1)
    {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        guard numberOfGridsSubAxis > 0 else {
            return
        }

        let isLengthMainAxisVertical = lengthMainAxis == .vertical
        var length = isLengthMainAxisVertical ? frame.height : frame.width
        length -= space * CGFloat(numberOfGridsSubAxis - 1)
        length -= isLengthMainAxisVertical ? (inset.top + inset.bottom) : (inset.left + inset.right)
        length /= CGFloat(numberOfGridsSubAxis)
        guard length > 0.0 else {
            return
        }

        var itemSize = CGSize.zero
        if isLengthMainAxisVertical {
            itemSize = CGSize(width: length * multiplierLengthSubAxis, height: length)
        } else {
            itemSize = CGSize(width: length, height: length * multiplierLengthSubAxis)
        }

        if size.width > 0 {
            itemSize.width = size.width
        } else if size.width < 0 {
            itemSize.width = length
        }

        if size.height > 0 {
            itemSize.height = size.height
        } else if size.height < 0 {
            itemSize.height = length
        }

        layout.itemSize = itemSize
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = inset
        layout.invalidateLayout()
    }
}
