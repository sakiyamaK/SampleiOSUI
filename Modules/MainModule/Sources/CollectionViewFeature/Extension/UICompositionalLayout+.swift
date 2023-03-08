//
//  UICompositionalLayout+.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2022/08/24.
//  Copyright © 2022 sakiyamaK. All rights reserved.
//

import UIKit.UICollectionViewCompositionalLayout

extension UICollectionViewCompositionalLayout {
    private static func createHeader(height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem? {
        guard height > 0 else { return nil }
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(height)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    private static func createFooter(height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem? {
        guard height > 0 else { return nil }
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(height)
            ),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
    }

    static func waterfall(contentInsets: NSDirectionalEdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8),
                          headerHeight: CGFloat = 0,
                          footerHeight: CGFloat = 0,
                          horizontalSpace: CGFloat = 8,
                          verticalSpace: CGFloat = 8,
                          numberOfColumn: CGFloat = 1,
                          numberOfItemsInSection: @escaping ((Int) -> Int),
                          cellHeight: @escaping (((width: CGFloat, index: Int)) -> CGFloat)) -> UICollectionViewLayout
    {
        UICollectionViewCompositionalLayout { section, environment -> NSCollectionLayoutSection? in

            // 各列の最後のitemのmaxYを保存するための辞書
            // 最初は全て0で初期化する
            var itemMaxYPerColumns: [Int: CGFloat] = Dictionary(
                uniqueKeysWithValues: (0 ..< Int(numberOfColumn)).map { ($0, 0) }
            )

            // セルひとつの横幅
            let width = (environment.container.effectiveContentSize.width
                - (contentInsets.leading + contentInsets.trailing)
                - (numberOfColumn - 1) * horizontalSpace) / numberOfColumn

            let items: [NSCollectionLayoutGroupCustomItem] = (0 ..< numberOfItemsInSection(section)).map { idx in
                // セルひとつの縦幅
                let height = cellHeight((width, idx))

                // セルの配置座標を計算
                let currentColumn = idx % Int(numberOfColumn)
                let currentRow = idx / Int(numberOfColumn)
                let preItemMaxY = (itemMaxYPerColumns[currentColumn] ?? 0.0)
                let y = preItemMaxY + (currentRow == 0 ? 0.0 : verticalSpace)
                let x = environment.container.contentInsets.leading + width * CGFloat(currentColumn) + horizontalSpace * CGFloat(currentColumn)

                // セルの配置frame
                let frame = CGRect(x: x, y: y, width: width, height: height)
                itemMaxYPerColumns[currentColumn] = frame.maxY
                let item = NSCollectionLayoutGroupCustomItem(frame: frame)
                return item
            }

            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: items.isEmpty ? .fractionalWidth(1.0) : .absolute(items.last!.frame.maxY)
            )

            // group
            let group = NSCollectionLayoutGroup.custom(layoutSize: layoutSize) { _ in
                items
            }

            // なぜかgroupが反応しない
            //            group.contentInsets = .init(top: 0, leading: contentInsets.leading, bottom: 0, trailing: contentInsets.trailing)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = contentInsets

            /*
             header footerの設定
             */
            let boundaryItems: [NSCollectionLayoutBoundarySupplementaryItem] =
                [createHeader(height: headerHeight), createFooter(height: footerHeight)]
                    .compactMap { $0 }
            if !boundaryItems.isEmpty {
                // セクションに登録
                section.boundarySupplementaryItems = boundaryItems
            }

            return section
        }
    }
}

