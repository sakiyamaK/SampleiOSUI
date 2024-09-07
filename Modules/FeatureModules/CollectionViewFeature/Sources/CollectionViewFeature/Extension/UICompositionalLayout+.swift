//
//  UICollectionViewCompositionalLayout+.swift
//  tcm-ios-simple
//
//  Created by sakiyamaK on 2021/06/07.
//

import UIKit
import Extensions

public extension UICollectionViewCompositionalLayout {
    
    static var table: UICollectionViewCompositionalLayout { table() }
    
    //標準のlistだとDiffableDatasourcesと組み合わせないとheader, footerの表示がバグる
    static func table(headerHeight: CGFloat = 0, footerHeight: CGFloat = 0) -> UICollectionViewCompositionalLayout {
        table(headerHeightInSection: {_ in
            headerHeight
        }) {_ in
            footerHeight
        }
    }
    
    static func table(
        headerHeightInSection: @escaping ((Int) -> CGFloat),
        headerPinToVisibleBounds: Bool = true,
        footerHeightInSection: @escaping ((Int) -> CGFloat),
        footerPinToVisibleBounds: Bool = false
    ) -> UICollectionViewCompositionalLayout {
        table(
            headerHeightDimensionInSection: { section in
                    .absolute(headerHeightInSection(section))
            },
            headerPinToVisibleBounds: headerPinToVisibleBounds,
            footerHeightInSection: footerHeightInSection,
            footerPinToVisibleBounds: footerPinToVisibleBounds
        )
    }
    
    static func table(
        headerHeightDimensionInSection: @escaping ((Int) -> NSCollectionLayoutDimension),
        headerPinToVisibleBounds: Bool = true,
        footerHeightInSection: @escaping ((Int) -> CGFloat),
        footerPinToVisibleBounds: Bool = false
    ) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {
            sectionIndex,
            environment -> NSCollectionLayoutSection? in
            // セクションにグループを登録する
            let section = NSCollectionLayoutSection(
                group: NSCollectionLayoutGroup.selfSizingTableGroup
            )
            
            /*
             header footerの設定
             */
            // セクションに登録
            section.boundarySupplementaryItems = [
                createHeader(heightDimension: headerHeightDimensionInSection(sectionIndex),
                             pinToVisible: headerPinToVisibleBounds
                            ),
                createFooter(
                    height: footerHeightInSection(sectionIndex),
                    pinToVisible: footerPinToVisibleBounds
                )
            ].compactMap({ $0 })
            
            return section
        }
    }
    
    static func horizontalScroll(
        widthDimension: NSCollectionLayoutDimension,
        heightDimension: NSCollectionLayoutDimension,
        itemContentInsets: NSDirectionalEdgeInsets,
        sectionContentInsets: NSDirectionalEdgeInsets = .zero,
        orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuous
    ) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout.init { _, _ -> NSCollectionLayoutSection? in
            
            // NSCollectionLayoutGroupのsubitems,countだとheightDimensionの値は関係ないらしい
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)
            )
            item.contentInsets = itemContentInsets
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(1.0),
                                                   heightDimension: .estimated(1.0)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
            section.contentInsets = sectionContentInsets
            
            return section
        }
    }
    
    static func waterfall(
        contentInsetsInSection: @escaping ((Int) -> NSDirectionalEdgeInsets),
        headerHeightInSection: @escaping ((Int) -> CGFloat),
        footerHeightInSection: @escaping ((Int) -> CGFloat),
        horizontalSpaceInSection: @escaping ((Int) -> CGFloat),
        verticalSpaceInSection: @escaping ((Int) -> CGFloat),
        numberOfColumnInSection: @escaping ((Int) -> CGFloat),
        numberOfItemsInSection: @escaping ((Int) -> Int),
        cellHeightInSection: @escaping ((Int, Int, CGFloat) -> CGFloat)
    ) -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {
            section,
            environment -> NSCollectionLayoutSection? in
            
            func makeNSCollectionLayoutGroupCustomItem(index: Int, cellWidth: CGFloat) -> NSCollectionLayoutGroupCustomItem {
                // 各Columnの中から一番Y座標が低いものを選ぶ
                guard let (minYColumn, maxY) = itemMaxYPerColumns.min(by: { lhs, rhs in
                    if lhs.value == rhs.value {
                        lhs.key < rhs.key
                    } else {
                        lhs.value < rhs.value
                    }
                }) else { fatalError() }
                
                // セルを配置する座標を計算する
                let y: CGFloat = maxY + (maxY == 0 ? 0.0 : verticalSpace)
                let x: CGFloat = environment.container.contentInsets.leading + width * CGFloat(minYColumn) + horizontalSpace * CGFloat(minYColumn)
                
                // セルひとつの縦幅
                let height = cellHeightInSection(section, index, cellWidth)
                
                // セルの配置
                let frame = CGRect(x: x, y: y, width: width, height: height)
                // 配置するclumnに最後に配置されたセルの下端のY座標を保存する
                itemMaxYPerColumns[minYColumn] = frame.maxY
                
                let item = NSCollectionLayoutGroupCustomItem(frame: frame)
                return item
            }
            
            let contentInsets = contentInsetsInSection(section)
            let headerHeight = headerHeightInSection(section)
            let footerHeight = footerHeightInSection(section)
            let horizontalSpace = horizontalSpaceInSection(section)
            let verticalSpace = verticalSpaceInSection(section)
            let numberOfColumn = numberOfColumnInSection(section)
            let numberOfItems = numberOfItemsInSection(section)
            
            // 各列の最後のitemのmaxYを保存するための辞書
            // 最初は全て0で初期化する
            var itemMaxYPerColumns: [Int: CGFloat] = Dictionary(
                uniqueKeysWithValues: (0 ..< Int(numberOfColumn)).map { ($0, 0) }
            )
            
            // セルひとつの横幅
            let width = (
                environment.container.effectiveContentSize.width
                - (contentInsets.leading + contentInsets.trailing)
                - (numberOfColumn - 1.0) * horizontalSpace
            ) / numberOfColumn
            
            
            let section: NSCollectionLayoutSection
            // numberOfColumnが1で普通のtableの扱いとする
            if numberOfColumn == 1 {
                let group = NSCollectionLayoutGroup.selfSizingTableGroup
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = verticalSpace
                section.contentInsets = contentInsets
            } else {
                let items: [NSCollectionLayoutGroupCustomItem] = (0 ..< numberOfItems).map {
                    makeNSCollectionLayoutGroupCustomItem(index: $0, cellWidth: width)
                }
                
                let layoutSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: items.isEmpty ? .fractionalHeight(1.0) : .absolute(itemMaxYPerColumns.max(by: { $0.value < $1.value })!.value)
                )
                
                let group = NSCollectionLayoutGroup.custom(layoutSize: layoutSize) { _ in
                    items
                }
                
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = contentInsets
            }
            
            
            /*
             header footerの設定
             */
            let boundaryItems: [NSCollectionLayoutBoundarySupplementaryItem] =
            [createHeader(heightDimension: .absolute(headerHeight)), createFooter(height: footerHeight)]
                .compactMap { $0 }
            if !boundaryItems.isEmpty {
                // セクションに登録
                section.boundarySupplementaryItems = boundaryItems
            }
            
            return section
        }
    }
}
private extension UICollectionViewCompositionalLayout {
    static func createHeader(heightDimension: NSCollectionLayoutDimension, pinToVisible: Bool = true) -> NSCollectionLayoutBoundarySupplementaryItem? {
        guard heightDimension.dimension > 0 else { return nil }
        let supplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: heightDimension
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        supplementary.pinToVisibleBounds = pinToVisible
        return supplementary
    }
    
    static func createFooter(height: CGFloat, pinToVisible: Bool = false) -> NSCollectionLayoutBoundarySupplementaryItem? {
        guard height > 0 else { return nil }
        let supplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(height)
            ),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        supplementary.pinToVisibleBounds = pinToVisible
        return supplementary
    }
}

private extension NSCollectionLayoutGroup {
    static var selfSizingTableGroup: NSCollectionLayoutGroup {
        //cellの高さに合わせる場合、itemSizeとgroupSizeを同じestimatedにする
        let selfSizeingHeight: NSCollectionLayoutDimension = .estimated(1.0)
        return NSCollectionLayoutGroup.vertical(
            // グループサイズの横幅をコレクションビューの横幅と同じ
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: selfSizeingHeight
            ),
            // アイテム設定に大きさを登録してインスタンスを作る
            subitems: [NSCollectionLayoutItem(
                // アイテム(セル)の大きさをグループの大きさと同じにする
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: selfSizeingHeight
                )
            )]
        )
    }
}
