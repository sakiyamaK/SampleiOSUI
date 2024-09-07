//
//  CompositionalLayout02ViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/3/21.
//

import DeclarativeUIKit
import UIKit

final class CompositionalLayout02ViewController: UIViewController {
    private let itemss = SampleModel02.sampless

    override func loadView() {
        super.loadView()

        view.backgroundColor = .white

        declarative {
            UICollectionView {
                // アイテムの横幅を親の0.2倍、高さを1倍にする
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.2),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                // グループの横幅を親の1.0倍,高さを55にする
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(55.0)
                )
                // 水平配置のグループを作成
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                // アイテム間の余白を最小で5にする
                group.interItemSpacing = .flexible(5)
                // グループの左右に10の余白を入れる
                group.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)

                // セクションを作成
                let section = NSCollectionLayoutSection(group: group)
                // グループ間の余白を設定
                section.interGroupSpacing = 30
                // sectionの上下に余白を設定
                section.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)

                /*
                 header footerの設定
                 */
                // フッタのためにサイズを用意
                let footerHeaderSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(50.0)
                )
                // ヘッダ
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerHeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                // フッタ
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerHeaderSize,
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottom
                )

                // セクションに登録
                section.boundarySupplementaryItems = [header, footer]

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

extension CompositionalLayout02ViewController: UICollectionViewDelegate {}

extension CompositionalLayout02ViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        itemss.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemss[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell01.reuseId, for: indexPath) as! UICollectionViewCell01)
            .configure(sample: itemss[indexPath.section][indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionHeaderView01.reuseId, for: indexPath) as! UICollectionHeaderView01)
                .configure(indexPath: indexPath)
        default:
            return (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionFooterView01.reuseId, for: indexPath) as! UICollectionFooterView01)
                .configure(indexPath: indexPath)
        }
    }
}

#Preview {
    CompositionalLayout02ViewController()
}
