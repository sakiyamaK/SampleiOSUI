//
//  CompositionalLayout05ViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/3/31.
//

import UIKit

final class CompositionalLayout05ViewController: UIViewController {
    private let items = SampleModel02.samples

    enum SectionKind: Int, CaseIterable {
        case continuous, groupPaging, none, continuousGroupLeadingBoundary, paging, groupPagingCentered

        var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .none:
                return .none
            case .continuous:
                return .continuous
            case .continuousGroupLeadingBoundary:
                return .continuousGroupLeadingBoundary
            case .paging:
                return .paging
            case .groupPaging:
                return .groupPaging
            case .groupPagingCentered:
                return .groupPagingCentered
            }
        }
    }

    override func loadView() {
        super.loadView()

        view.backgroundColor = .white

        declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout.init { sectionIndex, _ -> NSCollectionLayoutSection? in

                    let leftFractional: CGFloat = 0.7
                    let rightFractional: CGFloat = 1.0 - leftFractional

                    let leadingItem = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(leftFractional),
                                                           heightDimension: .fractionalHeight(1.0)))
                    leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

                    // NSCollectionLayoutGroupのsubitems,countだとheightDimensionの値は関係ないらしい
                    let trailingItem = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalHeight(1.0)))
                    trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

                    let trailingGroup = NSCollectionLayoutGroup.vertical(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(rightFractional),
                                                           heightDimension: .fractionalHeight(1.0)),
                        subitem: trailingItem, count: 2
                    )

                    // 横幅0.85にして横スクロールできることが分かるように次のグループをチラ見せしてる
                    // 縦幅0.4にして縦スクロールできることが分かるように次のセクションをチラ見せしてる
                    let containerGroup = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                                           heightDimension: .fractionalHeight(0.4)),
                        subitems: [leadingItem, trailingGroup]
                    )

                    let section = NSCollectionLayoutSection(group: containerGroup)
                    // 横スクロールの設定
                    let sectionKind = SectionKind(rawValue: sectionIndex)!
                    section.orthogonalScrollingBehavior = sectionKind.orthogonalScrollingBehavior

                    // header
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .absolute(20)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                    // セクションに登録
                    section.boundarySupplementaryItems = [header]

                    return section
                }
            }
            .registerCellClass(UICollectionViewCell01.self, forCellWithReuseIdentifier: UICollectionViewCell01.reuseId)
            .registerViewClass(UICollectionHeaderView01.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UICollectionHeaderView01.reuseId)
            .backgroundColor(.systemGray)
            .dataSource(self)
            .delegate(self)
        }
    }
}

extension CompositionalLayout05ViewController: UICollectionViewDelegate {}

extension CompositionalLayout05ViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        SectionKind.allCases.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell01.reuseId, for: indexPath) as! UICollectionViewCell01)
            .configure(sample: items[indexPath.item], cornerRadius: 8)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionKind = SectionKind(rawValue: indexPath.section)!
        return (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionHeaderView01.reuseId, for: indexPath) as! UICollectionHeaderView01)
            .configure(text: "." + String(describing: sectionKind))
    }
}
