//
//  Sample4CollectionViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/07.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

// 自作のCellクラスを使った実装

import UIKit

final class Sample4CollectionViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(MyCollectionViewCell.nib, forCellWithReuseIdentifier: MyCollectionViewCell.reuseIdentifier)
            /*
             UICollectionViewFlowLayoutを設定すればそちらが優先でレイアウトが組まれる
             なければMyCollectionViewCellの誓約にしたがってレイアウトが組まれる
             */
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 150, height: 150)
            collectionView.collectionViewLayout = layout
        }
    }

    let items = SampleModel.demoData
}

extension Sample4CollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // セルの再利用
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.reuseIdentifier, for: indexPath) as? MyCollectionViewCell else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.item]
        cell.configure(sampleModel: item)
        return cell
    }
}
