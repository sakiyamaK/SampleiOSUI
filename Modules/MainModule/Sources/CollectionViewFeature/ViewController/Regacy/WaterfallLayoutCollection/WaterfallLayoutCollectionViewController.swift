//
//  WaterfallLayoutCollectionViewController.swift
//  SampleCollectionView
//
//  Created by  on 2021/11/5.
//

import UIKit

final class WaterfallLayoutCollectionViewController: UIViewController {
    private var samples = SampleModel.getDemoData(count: 100)

    private lazy var collectionLayout = CHTCollectionViewWaterfallLayout()
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionLayout.columnCount = 2
            collectionLayout.itemRenderDirection = CHTCollectionViewWaterfallLayout.ItemRenderDirection.leftToRight
            collectionLayout.minimumColumnSpacing = 15
            collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            collectionView.collectionViewLayout = collectionLayout
            collectionView.register(MyCollectionViewCell2.nib, forCellWithReuseIdentifier: MyCollectionViewCell2.reuseIdentifier)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
}

extension WaterfallLayoutCollectionViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        switch indexPath.section {
        case 0:
            width = (collectionView.frame.width - collectionLayout.sectionInset.left - collectionLayout.sectionInset.right)
        default:
            width = (collectionView.frame.width - collectionLayout.sectionInset.left - collectionLayout.sectionInset.right) / 2
        }
        return MyCollectionViewCell2.calcSize(width: width, sampleModel: samples[indexPath.item])
    }

    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        columnCountFor section: Int) -> Int
    {
        switch section {
        case 0: return 1
        default: return 2
        }
    }
}

extension WaterfallLayoutCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        2
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        default: return samples.count - 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell2.reuseIdentifier, for: indexPath) as! MyCollectionViewCell2).configure(sampleModel: samples[indexPath.item])
    }
}

extension UIStoryboard {
    static var waterfallLayoutCollection: WaterfallLayoutCollectionViewController {
        UIStoryboard(name: "WaterfallLayoutCollection", bundle: Bundle.module).instantiateInitialViewController() as! WaterfallLayoutCollectionViewController
    }
}
