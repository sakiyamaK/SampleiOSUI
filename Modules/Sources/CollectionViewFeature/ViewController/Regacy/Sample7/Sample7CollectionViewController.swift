//
//  SampleCollection7ViewController.swift
//  SampleCollectionView
//
//  Created by  on 2021/3/11.
//

// WWDC 2018のサンプル
// https://developer.apple.com/videos/play/wwdc2018/225/

import UIKit

final class Sample7CollectionViewController: UIViewController {
    private let items = SampleModel.demoData

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            let layout = ColumnFlowLayout()
            layout.layoutType = .type1
            collectionView.collectionViewLayout = layout
            collectionView.register(MyCollectionViewCell2.nib(bundle: .module), forCellWithReuseIdentifier: MyCollectionViewCell2.className)
        }
    }
}

extension Sample7CollectionViewController: UICollectionViewDelegate {}

extension Sample7CollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell2.className, for: indexPath) as! MyCollectionViewCell2
        let item = items[indexPath.item]
        cell.configure(sampleModel: item)
        return cell
    }
}

#Preview {
    Sample7CollectionViewController.makeFromStroryboard(name: "Sample7Collection", bundle: .module)!
}
