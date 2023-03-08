//
//  VHScrollLayout.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2022/07/02.
//  Copyright © 2022 sakiyamaK. All rights reserved.
//

import UIKit

final class VHScrollLayout: UICollectionViewLayout {
    private var cachedAttributess = [UICollectionViewLayoutAttributes]()

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        cachedAttributess.removeAll()

        let size: CGFloat = 100
        let space: CGFloat = 10

        let cgRects: [CGRect] = (0 ..< collectionView.numberOfItems(inSection: 0)).map { _ in
            let x = CGFloat(Int.random(in: 0 ... 50)) * (size + space)
            let y = CGFloat(Int.random(in: 0 ... 50)) * (size + space)
            return CGRect(
                x: x,
                y: y,
                width: size,
                height: size
            )
        }

        cachedAttributess.append(
            contentsOf: cgRects.getUICollectionViewLayoutAttributes()
        )
    }

    // 全体のcontentSizeを教える
    override var collectionViewContentSize: CGSize {
        print(cachedAttributess.contentSize)
        return cachedAttributess.contentSize
    }

    // contentSizeが更新されたか確認する？？
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        !newBounds.size.equalTo(collectionView?.bounds.size ?? .zero)
    }

    // indexPath番目のUICollectionViewLayoutAttributes(レイアウト属性)を取得する
    // UICollectionViewLayoutAttributesの中に表示すべきframeがあるのでどこに表示するのか分かる
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributess[indexPath.item]
    }

    // 表示領域(rect)から次の[UICollectionViewLayoutAttributes]を取得する
    override func layoutAttributesForElements(in _: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributess
//        cachedAttributess.getUICollectionViewLayoutAttributesIn(rect: rect)
    }
}

private extension Array where Element == CGRect {
    func getUICollectionViewLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        enumerated().map { index, segmentFrame in
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
            attributes.frame = segmentFrame
            return attributes
        }
    }
}

private extension Array where Element == UICollectionViewLayoutAttributes {
    var lastFrame: CGRect { last?.frame ?? .zero }

    var contentSize: CGSize {
        // CGRect.zeroの位置から、lastFrameが入る最小Rectを求めることでコンテンツのサイズとなる
        CGRect.zero.union(lastFrame).size
    }
}
