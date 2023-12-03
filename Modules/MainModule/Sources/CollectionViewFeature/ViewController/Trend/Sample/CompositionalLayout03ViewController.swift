//
//  CompositionalLayout03ViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/3/22.
//

import UIKit

final class CompositionalLayout03ViewController: UIViewController {
    private let itemss = SampleModel02.sampless

    override func loadView() {
        super.loadView()

        applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UICollectionView {
                let leftFractional: CGFloat = 0.7
                let rightFractional: CGFloat = 1.0 - leftFractional
                // 左側のアイテム
                let leadingItem = NSCollectionLayoutItem(
                    // グループに対する比率
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(leftFractional),
                                                       heightDimension: .fractionalHeight(1.0))
                )
                // 余白
                leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

                // 右側
                let trailingItem = NSCollectionLayoutItem(
                    // グループに対する比率 NSCollectionLayoutGroupがsubitem指定だと関係ない
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0))
                )
                // 余白
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

                // 右側のアイテムグループ　縦並びにするからvertical
                let trailingGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(rightFractional),
                                                       heightDimension: .fractionalHeight(1.0)),
                    subitems: [trailingItem, trailingItem]
                )

                // sectionに入れる大元となるグループ
                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    // colelctionviewに対する比率
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.4)),
                    // 右側はネストされたグループを入れる
                    subitems: [leadingItem, trailingGroup]
                )

                let section = NSCollectionLayoutSection(group: nestedGroup)

                let layout = UICollectionViewCompositionalLayout(section: section)

                return layout
            }
            .registerCellClass(UICollectionViewCell01.self, forCellWithReuseIdentifier: UICollectionViewCell01.reuseId)
            .registerViewClass(UICollectionHeaderView01.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UICollectionHeaderView01.reuseId)
            .registerViewClass(UICollectionFooterView01.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionFooterView01.reuseId)
            .backgroundColor(.systemGray)
            .dataSource(self)
            .delegate(self)
        }
    }
}

extension CompositionalLayout03ViewController: UICollectionViewDelegate {}

extension CompositionalLayout03ViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        itemss.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemss[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell01.reuseId, for: indexPath) as! UICollectionViewCell01).configure(sample: itemss[indexPath.section][indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionHeaderView01.reuseId, for: indexPath) as! UICollectionHeaderView01).configure(indexPath: indexPath)
        default:
            return (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionHeaderView01.reuseId, for: indexPath) as! UICollectionHeaderView01).configure(indexPath: indexPath)
        }
    }
}
