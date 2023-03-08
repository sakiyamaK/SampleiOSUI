//
//  Sample5CollectionViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/07.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

// 自作のCellクラスを使った実装

import UIKit

final class Sample5CollectionViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(MyCollectionViewCell2.nib, forCellWithReuseIdentifier: MyCollectionViewCell2.reuseIdentifier)
        }
    }

    let items = SampleModel.demoData

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }
}

extension Sample5CollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // セルの再利用
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell2.reuseIdentifier, for: indexPath) as? MyCollectionViewCell2 else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.item]
        cell.configure(sampleModel: item)
        return cell
    }
}

// extension Sample5CollectionViewController: UICollectionViewDelegateFlowLayout {
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let item = items[indexPath.item]
//    let size = MyCollectionViewCell2.calcSize(width: 150, sampleModel: item, indexPath: indexPath)
//    return size
//  }
// }
