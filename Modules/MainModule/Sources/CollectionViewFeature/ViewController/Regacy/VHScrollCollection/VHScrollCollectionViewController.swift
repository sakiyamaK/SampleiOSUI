//
//  VHScrollCollectionViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2022/07/02.
//  Copyright © 2022 sakiyamaK. All rights reserved.
//

import Photos
import UIKit

final class VHScrollCollectionViewController: UIViewController {
    typealias Cell = MyCollectionViewCell3

    private var samples = SampleModel.getDemoData(count: 200)

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(Cell.nib, forCellWithReuseIdentifier: Cell.reuseIdentifier)
            collectionView.collectionViewLayout = VHScrollLayout()
            collectionView.alwaysBounceVertical = true
            collectionView.alwaysBounceHorizontal = true
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

extension VHScrollCollectionViewController: UICollectionViewDelegate {}

extension VHScrollCollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        samples.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell).configure(sampleModel: samples[indexPath.item])
    }
}
