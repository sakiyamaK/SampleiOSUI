//
//  SampleSwiftDataCollectionViewController.swift
//  Modules
//
//  Created by sakiyamaK on 2025/02/10.
//

import UIKit
import DeclarativeUIKit
import ObservableUIKit
import SwiftData

public class SampleSwiftDataCollectionViewController: UIViewController {

    private var modelContext: ModelContext!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
    private var models: [Item] {
        (try? modelContext.fetch(FetchDescriptor<Item>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)]))) ?? []
    }

    public convenience init(modelContext: ModelContext) {
        self.init(nibName: nil, bundle: nil)
        self.modelContext = modelContext
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
            }.apply {[weak self] collectionView in
                let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, item in
                    cell.contentConfiguration = UIListContentConfiguration.cell()
                        .text(item.timestamp.description)
                    cell.accessories = [.disclosureIndicator()]
                }

                self!.dataSource = UICollectionViewDiffableDataSource<Int, Item>(
                    collectionView: collectionView
                ) { collectionView, indexPath, item in
                    collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
                }
            }.apply {[weak self] _ in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
                snapshot.appendSections([0])
                snapshot.appendItems(self!.models)
                self!.dataSource.apply(snapshot, animatingDifferences: false)
            }
        }.applyNavigationItem {
            $0.rightBarButtonItem = .init(
                customView: UIButton(
                    configuration: .plain().image(UIImage(systemName: "plus")),
                    primaryAction: .init(
                        handler: { [weak self] _ in

                            guard let self,
                                  let context = self.modelContext else { return }
                            context.insert(Item(timestamp: Date()))
                            try? context.save()
                            var snapshot = dataSource.snapshot()
                            snapshot.appendItems(self.models.filter {
                                !snapshot.itemIdentifiers.map { $0.id }.contains($0.id)
                            })
                        dataSource.apply(snapshot)
                    })
                )
            )
        }.applyView {
            $0.backgroundColor = .secondarySystemBackground
        }
    }
}
