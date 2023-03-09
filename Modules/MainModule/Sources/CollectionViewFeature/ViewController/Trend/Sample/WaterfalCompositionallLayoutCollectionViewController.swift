//
//  WaterfallLayout.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2022/08/24.
//  Copyright © 2022 sakiyamaK. All rights reserved.
//

import DeclarativeUIKit
import UIKit

final class WaterfalCompositionallLayoutCollectionViewController: UIViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, SampleImageModel>!

    private weak var collectionView: UICollectionView!
    private weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout.waterfall(
                    contentInsets: .init(top: 16, leading: 16, bottom: 16, trailing: 16),
                    horizontalSpace: 10,
                    verticalSpace: 10,
                    numberOfColumn: 2,
                    numberOfItemsInSection: {[weak self] (section) in
                        guard let self = self else { return 0 }
                        let number = self.dataSource.collectionView(self.collectionView, numberOfItemsInSection: section)
                        return number
                    }, cellHeight: {[weak self] (width, index) -> CGFloat in
                        guard
                            let self = self,
                            let sample = self.dataSource.itemIdentifier(for: .init(row: index, section: 0))
                        else { return 0 }
                        let size = UIImageViewCell.calcSize(width: width, sample: sample)
                        return size.height
                    })
            }
            .assign(to: &collectionView)
            .registerCellClass(UIImageViewCell.self, forCellWithReuseIdentifier: UIImageViewCell.reuseId)
            .apply { [weak self] in
                guard let self = self else { return }
                self.dataSource = UICollectionViewDiffableDataSource<Int, SampleImageModel>(collectionView: $0) {
                    (collectionView: UICollectionView, indexPath: IndexPath, sample: SampleImageModel) -> UIImageViewCell in
                    (collectionView.dequeueReusableCell(withReuseIdentifier: UIImageViewCell.reuseId, for: indexPath) as! UIImageViewCell)
                        .configure(sample: sample)
                }
            }
            .refreshControl({
                UIRefreshControl().add(target: self, for: .valueChanged) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        guard let self = self else { return }
                        self.collectionView.refreshControl?.endRefreshing()
                        print("ロード終了")

                    }
                }
            })
        }
        
        declarative(reset: false) {
            UIActivityIndicatorView(assign: &indicator)
                .hidesWhenStopped(true)
                .apply {
                    $0.startAnimating()
                }
                .center()
        }
        
        SampleImageModel.load(times: 100) {[weak self] samples in
            guard let self = self else { return }
            self.indicator.isHidden = true
            var snapshot = NSDiffableDataSourceSnapshot<Int, SampleImageModel>()
            // セクションの数を登録する
            snapshot.appendSections([0])
            // セルの配列を登録する
            snapshot.appendItems(samples)
            // データソースにsnapshotを適応させる
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
