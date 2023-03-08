//
//  CompositionalLayout06ViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/3/31.
//

import UIKit

final class SectionBackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("not implemented")
    }
}

extension SectionBackgroundDecorationView {
    func configure() {
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
}

final class CompositionalLayout06ViewController: UIViewController {
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
                let layout = UICollectionViewCompositionalLayout.init { _, _ -> NSCollectionLayoutSection? in

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

                    let containerGroup = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                                           heightDimension: .fractionalHeight(0.4)),
                        subitems: [leadingItem, trailingGroup]
                    )

                    let section = NSCollectionLayoutSection(group: containerGroup)
                    section.orthogonalScrollingBehavior = .continuous
                    section.interGroupSpacing = 5
                    section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)

                    // sectionの背景をデコレーション
                    let decorationItem: NSCollectionLayoutDecorationItem = .background(elementKind: SectionBackgroundDecorationView.reuseId)
                    decorationItem.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)

                    section.decorationItems = [decorationItem]
                    return section
                }

                layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.reuseId)
                return layout
            }
            .registerCellClass(UICollectionViewCell01.self, forCellWithReuseIdentifier: UICollectionViewCell01.reuseId)
            .backgroundColor(.systemGray)
            .dataSource(self)
            .delegate(self)
        }
    }
}

extension CompositionalLayout06ViewController: UICollectionViewDelegate {}

extension CompositionalLayout06ViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        10
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell01.reuseId, for: indexPath) as! UICollectionViewCell01)
            .configure(sample: items[indexPath.item], cornerRadius: 8)
    }
}
