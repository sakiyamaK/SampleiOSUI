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

    private weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        
        self.declarative {
            UICollectionView {
                MosaicLayout()
            }
            .assign(to: &collectionView)
            .alwaysBounceVertical(true)
            .indicatorStyle(.white)
            .delegate(self)
            .dataSource(self)
            .apply {
                $0.register(
                    MyCollectionViewCell2.nib,
                    forCellWithReuseIdentifier: MyCollectionViewCell2.reuseIdentifier
                )
            }
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
