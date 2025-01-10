//
//  WaterfallLayout.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2022/08/24.
//  Copyright © 2022 sakiyamaK. All rights reserved.
//

import DeclarativeUIKit
import UIKit
import Extensions

final class WaterfalCompositionallLayoutCollectionViewController: UIViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, SampleImageModel>!

    private weak var collectionView: UICollectionView!
    private weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout.waterfall(
                    contentInsetsInSection: { _ in .init(top: 16, leading: 16, bottom: 16, trailing: 16) },
                    headerHeightInSection: { _ in 0 },
                    footerHeightInSection: { _ in 0 },
                    horizontalSpaceInSection: { _ in 10 },
                    verticalSpaceInSection: { _ in 10 },
                    numberOfColumnInSection: { section in
                        CGFloat(section + 1)
                    },
                    numberOfItemsInSection: {[weak self] section in
                            guard let self = self else { return 0 }
                            let number = self.dataSource.collectionView(self.collectionView, numberOfItemsInSection: section)
                            return number
                    }, cellHeightInSection: {[weak self] section, itemIndex, cellWidth in
                        guard
                            let self,
                            section != 0,
                            let sample = self.dataSource.itemIdentifier(for: .init(row: itemIndex, section: section))
                        else {
                            return 0
                        }
                        let size = UIImageViewCell.calcSize(width: cellWidth, sample: sample)
                        return size.height
                    })
            }
            .assign(to: &self.collectionView)
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
                UIRefreshControl()
                    .addAction(.touchUpInside, handler: { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        guard let self = self else { return }
                        self.collectionView.refreshControl?.endRefreshing()
                    }
                })
            })
        }.declarative {
            UIActivityIndicatorView(assign: &self.indicator)
                .hidesWhenStopped(true)
                .apply {
                    $0.startAnimating()
                }
                .center()
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, SampleImageModel>()
        // セクションの数を登録する
        let sections = [0, 1, 2, 3]
        let numOfItem = 10
        snapshot.appendSections(sections)
        SampleImageModel.load(times: numOfItem * sections.count) {[weak self] samples in
            guard let self else { return }
            self.indicator.isHidden = true
            // セルの配列を登録する
            sections.forEach { section in
                snapshot.appendItems(Array(samples[numOfItem*section..<numOfItem * (section + 1)]), toSection: section)
            }
            self.dataSource.apply(snapshot)
        }
//        SampleImageModel.load(times: 30) {[weak self] samples in
//            guard let self else { return }
//            self.indicator.isHidden = true
//            // セルの配列を登録する
//            snapshot.appendItems(samples, toSection: 1)
//        }
//        SampleImageModel.load(times: 30) {[weak self] samples in
//            guard let self else { return }
//            self.indicator.isHidden = true
//            // セルの配列を登録する
//            snapshot.appendItems(samples, toSection: 2)
//        }
    }
}

#Preview {
    WaterfalCompositionallLayoutCollectionViewController()
}
