//
//  SampleCollection7ViewController.swift
//  SampleCollectionView
//
//  Created by  on 2021/3/11.
//

// WWDC 2018のサンプル
// https://developer.apple.com/videos/play/wwdc2018/225/

import UIKit

final class SampleCollection7ViewController: UIViewController {
    private let items = SampleModel.demoData

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            let layout = ColumnFlowLayout()
            layout.layoutType = .type1
            collectionView.collectionViewLayout = layout
            collectionView.register(MyCollectionViewCell2.nib, forCellWithReuseIdentifier: MyCollectionViewCell2.reuseIdentifier)
        }
    }
}

extension SampleCollection7ViewController: UICollectionViewDelegate {}

extension SampleCollection7ViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell2.reuseIdentifier, for: indexPath) as! MyCollectionViewCell2
        let item = items[indexPath.item]
        cell.configure(sampleModel: item)
        return cell
    }
}
