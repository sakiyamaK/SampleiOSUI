//
//  CompositionalLayout09ViewController.swift
//  SampleCompositonalLayout
//
//  Created by sakiyamaK on 2022/08/06.
//

import UIKit

final class CompositionalLayout09ViewController: UIViewController {
    private let items = SampleModel02.samples

    override func loadView() {
        super.loadView()

        applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout.init { _, _ -> NSCollectionLayoutSection? in

                    // NSCollectionLayoutGroupのsubitems,countだとheightDimensionの値は関係ないらしい
                    let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(100),
                                                           heightDimension: .absolute(100)))
                    item.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 10, bottom: 10, trailing: 10)

                    let containerGroup = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(1.0),
                                                           heightDimension: .estimated(1.0)),
                        subitems: [item]
                    )

                    let section = NSCollectionLayoutSection(group: containerGroup)
                    section.orthogonalScrollingBehavior = .groupPaging

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

extension CompositionalLayout09ViewController: UICollectionViewDelegate {}

extension CompositionalLayout09ViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell01.reuseId, for: indexPath) as! UICollectionViewCell01)
            .configure(sample: items[indexPath.item], cornerRadius: 8)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
}

#Preview {
    CompositionalLayout09ViewController()
}
