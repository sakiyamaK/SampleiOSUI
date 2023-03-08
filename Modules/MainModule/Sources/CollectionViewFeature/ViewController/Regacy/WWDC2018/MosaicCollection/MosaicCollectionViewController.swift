//
//  MosaicCollectionViewController.swift
//  SampleCollectionView
//
//  Created by  on 2021/10/24.
//

import Photos
import UIKit

final class MosaicCollectionViewController: UIViewController {
    private var samples = SampleModel.getDemoData(count: 100)

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(MyCollectionViewCell2.nib, forCellWithReuseIdentifier: MyCollectionViewCell2.reuseIdentifier)
            collectionView.collectionViewLayout = MosaicLayout()
            collectionView.alwaysBounceVertical = true
            collectionView.indicatorStyle = .white
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }
}

extension MosaicCollectionViewController: UICollectionViewDelegate {}

extension MosaicCollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        samples.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell2.reuseIdentifier, for: indexPath) as! MyCollectionViewCell2).configure(sampleModel: samples[indexPath.item])
    }
}
