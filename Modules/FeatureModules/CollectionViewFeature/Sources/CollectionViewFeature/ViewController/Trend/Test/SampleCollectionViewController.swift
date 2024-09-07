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
    
    private var items1: [Item] = [
        .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
        .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
        .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
        .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
        .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
    ]
    
    private var items2: [Item] = [
        .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
        .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
        .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
        .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
        .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
    ]

    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.applyView({
            $0.backgroundColor(.systemBackground)
        }).applyNavigationItem({
            $0.title = "Sample"
        }).declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout.list(
                    using: .init(
                        appearance: .insetGrouped
                    )
                )
            }
            .apply({ collectionView in
                // dequeueConfiguredReusableCellでその都度生成はできないのでちゃんと定数化しておく
                let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { [weak self] (cell, indexPath, item) in
                    DLog(indexPath)
                    return cell.contentConfiguration = CustomContentConfiguration(
                        item: item,
                        delegate: .init(
                            tapButton: {[weak self] _ in
                            }
                        )
                    )
                }
                
                dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView) {
                    (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
                    collectionView.dequeueConfiguredReusableCell(
                        using: cellRegistration,
                        for: indexPath,
                        item: item
                    )
                }
            })
        }
        
        // initial data
        self.applySnapshot(items: [items1, items2], animatingDifferences: false)
    }

    private func applySnapshot(items: [[Item]], animatingDifferences: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0, 2])
        snapshot.appendItems(items[0], toSection: 0)
        snapshot.appendItems(items[1], toSection: 2)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
