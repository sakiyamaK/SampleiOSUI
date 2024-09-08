//
//  CompositionalLayout07ViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/4/3.
//

import UIKit

final class CompositionalLayout07ViewController: UIViewController {
    private let items = SampleModel02.samples

    override func loadView() {
        super.loadView()

        view.backgroundColor = .white

        declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout.init { _, _ -> NSCollectionLayoutSection? in

                    let widthHalfSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.5),
                        heightDimension: .fractionalHeight(1.0)
                    )
                    let heightHalfSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(0.5)
                    )

                    let widthHalfItem = NSCollectionLayoutItem(layoutSize: widthHalfSize)
                    widthHalfItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

                    let heightHalfItem = NSCollectionLayoutItem(layoutSize: heightHalfSize)
                    heightHalfItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

                    var groups: [NSCollectionLayoutGroup] = []
                    
                    let last = Int.random(in: 2 ... 20)
                    
                    for idx in 0 ..< last {
                        let isHorizontal = if last % 2 == 0 {
                            if idx == last - 1 {
                                true
                            } else {
                                if idx % 2 == 0 {
                                    false
                                } else {
                                    true
                                }
                            }
                        } else {
                            if idx == last {
                                true
                            } else {
                                if idx % 2 == 0 {
                                    true
                                } else {
                                    false
                                }
                            }
                        }
                        
                        let subitems: [NSCollectionLayoutItem] = if isHorizontal {
                            [widthHalfItem, idx == 0 ? widthHalfItem : groups.last!]
                        } else {
                            [heightHalfItem, idx == 0 ? heightHalfItem : groups.last!]
                        }

                        let size: NSCollectionLayoutSize = if idx == last - 1 {
                            heightHalfSize
                        } else {
                            isHorizontal ? heightHalfSize : widthHalfSize
                        }

                        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: subitems)
                        groups.append(group)
                    }

                    let lastGroup = groups.last!

                    let section = NSCollectionLayoutSection(group: lastGroup)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

                    return section
                }
            }
            .registerCellClass(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.reuseId)
            .backgroundColor(.systemGray)
            .dataSource(self)
            .delegate(self)
        }
    }
}

extension CompositionalLayout07ViewController: UICollectionViewDelegate {}

extension CompositionalLayout07ViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reuseId, for: indexPath)
        cell.backgroundColor = indexPath.item % 2 == 0 ? .systemRed : .systemBlue
        return cell
    }
}

#Preview {
    CompositionalLayout07ViewController()
}
