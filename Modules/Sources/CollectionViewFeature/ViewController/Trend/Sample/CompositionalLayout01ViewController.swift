//
//  CompositionalLayout01ViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/3/21.
//

import DeclarativeUIKit
import UIKit
import Extensions

final class CompositionalLayout01ViewController: UIViewController {
    private let items = SampleModel02.samples
    
    private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyView {
            $0.backgroundColor(.white)
        }
        .declarative {
            UICollectionView {
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(44)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                
                section.visibleItemsInvalidationHandler = {[weak self] items, point, environment in
                    // 真ん中だけ黄色
                    let middleIndexPath = items[items.count/2].indexPath
                    if let cell = self!.collectionView.cellForItem(at: middleIndexPath) {
                        cell.contentView.backgroundColor = .yellow
                    }
                    // 他は白
                    for indexPath in items.compactMap({ $0.indexPath }).filter({ $0 != middleIndexPath }) {
                        if let cell = self!.collectionView.cellForItem(at: indexPath) {
                            cell.contentView.backgroundColor = .white
                        }
                    }
                }

                let layout = UICollectionViewCompositionalLayout(section: section)
                return layout
            }
            .registerCellClass(UICollectionViewCell01.self, forCellWithReuseIdentifier: UICollectionViewCell01.reuseId)
            .backgroundColor(.systemGray)
            .assign(to: &collectionView)
            .dataSource(self)
            .delegate(self)
        }
    }
}

extension CompositionalLayout01ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DLog()
    }
}

extension CompositionalLayout01ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell01.reuseId, for: indexPath) as! UICollectionViewCell01
        cell.configure(sample: items[indexPath.item])
        return cell
    }
}

#Preview {
    CompositionalLayout01ViewController()
}
