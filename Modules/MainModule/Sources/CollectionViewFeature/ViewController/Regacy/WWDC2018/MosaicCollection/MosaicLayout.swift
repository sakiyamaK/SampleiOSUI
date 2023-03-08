//
//  MosaicLayout.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2021/10/24.
//  Copyright © 2021 sakiyamaK. All rights reserved.
//

import UIKit

final class MosaicLayout: UICollectionViewLayout {
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()

    private let nextSegmentSpace: CGFloat
    private let segmentHeight: CGFloat

    init(nextSegmentSpace: CGFloat = 1.0, segmentHeight: CGFloat = 200.0) {
        self.nextSegmentSpace = nextSegmentSpace
        self.segmentHeight = segmentHeight
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        cachedAttributes.removeAll()

        let numOfItems = collectionView.numberOfItems(inSection: 0)

        var segment: MosaicSegmentStyle = .fullWidth

        var lastIndex = 0

        while lastIndex < numOfItems {
            // 1行をセグメントという単位としている
            // segmentFrameはその大きさと座標
            let mainFrame = CGRect(
                x: 0, y: cachedAttributes.lastFrame.maxY + nextSegmentSpace,
                width: collectionView.bounds.size.width, height: segmentHeight
            )
            // mainFrameをsegmentの設定に基づいて分割する
            let segmentFrames = mainFrame.dividedAt(segment: segment)

            // 表示するFrameの配列からUICollectionViewLayoutAttributesへと変換して保存しておく
            cachedAttributes.append(
                contentsOf: segmentFrames.getUICollectionViewLayoutAttributes(lastIndex: lastIndex)
            )

            lastIndex += segmentFrames.count

            segment = segment.getNextMosaicSegmentStyle(retainItems: numOfItems - lastIndex)
        }
    }

    // 全体のcontentSizeを教える
    override var collectionViewContentSize: CGSize {
        return cachedAttributes.contentSize
    }

    // contentSizeが更新されたか確認する？？
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        !newBounds.size.equalTo(collectionView?.bounds.size ?? .zero)
    }

    // indexPath番目のUICollectionViewLayoutAttributes(レイアウト属性)を取得する
    // UICollectionViewLayoutAttributesの中に表示すべきframeがあるのでどこに表示するのか分かる
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributes[indexPath.item]
    }

    // 表示領域(rect)から次の[UICollectionViewLayoutAttributes]を取得する
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cachedAttributes.getUICollectionViewLayoutAttributesIn(rect: rect)
    }
}

enum MosaicSegmentStyle: Int, CaseIterable {
    case fullWidth = 0
    case fiftyFifty
    case twoThirdsOneThird
    case oneThirdTwoThirds

    func getNextMosaicSegmentStyle(retainItems: Int) -> MosaicSegmentStyle {
        switch retainItems {
        case 1:
            return .fullWidth
        case 2:
            return .fiftyFifty
        default:
            // styleを次のやつに変える
            return .init(rawValue: (rawValue + 1) % MosaicSegmentStyle.allCases.count)!
        }
    }
}

private extension CGRect {
    private func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat

        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = size.width
        case .minYEdge, .maxYEdge:
            dimension = size.height
        }

        let distance = (dimension * fraction).rounded(.up)
        var slices = divided(atDistance: distance, from: fromEdge)

        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.remainder.origin.x += 1
            slices.remainder.size.width -= 1
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += 1
            slices.remainder.size.height -= 1
        }

        return (first: slices.slice, second: slices.remainder)
    }

    func dividedAt(segment: MosaicSegmentStyle) -> [CGRect] {
        switch segment {
        case .fullWidth:
            return [self]

        case .fiftyFifty:
            let horizontalSlices = dividedIntegral(fraction: 0.5, from: .minXEdge)
            return [horizontalSlices.first, horizontalSlices.second]

        case .twoThirdsOneThird:
            let horizontalSlices = dividedIntegral(fraction: 2.0 / 3.0, from: .minXEdge)
            let verticalSlices = horizontalSlices.second.dividedIntegral(fraction: 0.5, from: .minYEdge)
            return [horizontalSlices.first, verticalSlices.first, verticalSlices.second]

        case .oneThirdTwoThirds:
            let horizontalSlices = dividedIntegral(fraction: 1.0 / 3.0, from: .minXEdge)
            let verticalSlices = horizontalSlices.first.dividedIntegral(fraction: 0.5, from: .minYEdge)
            return [verticalSlices.first, verticalSlices.second, horizontalSlices.second]
        }
    }
}

private extension Array where Element == CGRect {
    func getUICollectionViewLayoutAttributes(lastIndex: Int) -> [UICollectionViewLayoutAttributes] {
        enumerated().map { index, segmentFrame in
            let item = lastIndex + index
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
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

    func getUICollectionViewLayoutAttributesIn(rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        guard let lastIndex = indices.last,
              let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex)
        else {
            return []
        }

        var attributesArray = [UICollectionViewLayoutAttributes]()

        for attributes in self[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }

        for attributes in self[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }

        return attributesArray
    }

    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }

        let mid = (start + end) / 2
        let attr = self[mid]

        if attr.frame.intersects(rect) {
            return mid
        }
        if attr.frame.maxY < rect.minY {
            return binSearch(rect, start: mid + 1, end: end)
        }

        return binSearch(rect, start: start, end: mid - 1)
    }
}
