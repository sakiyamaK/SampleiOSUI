//
//  SampleCollectionViewController.swift
//
//
//  Created by sakiyamaK on 2024/06/28.
//

import DeclarativeUIKit
import UIKit
import Extensions

public class SampleCollectionViewController: UIViewController {
    
    deinit { DLog() }
        
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.applyView({
            $0.backgroundColor(.systemBackground)
        }).applyNavigationItem({
            $0.title = "Sample"
        }).declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout.init { sectionIndex, environment in
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
                    
                    section.visibleItemsInvalidationHandler = { items, point, environment in
                        DLog(items.count)
                        DLog(point)
                    }
                    
                    return section
                }
            }
            .apply({ collectionView in
            })
        }
    }
}

#Preview {
    SampleCollectionViewController()
}
