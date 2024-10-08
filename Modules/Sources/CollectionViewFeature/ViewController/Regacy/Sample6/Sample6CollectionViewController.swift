//
//  Sample6CollectionViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/09.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

// 自作のCellクラスを綺麗に並べる実装

import UIKit

final class Sample6CollectionViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(MyCollectionViewCell2.nib(bundle: .module), forCellWithReuseIdentifier: MyCollectionViewCell2.className)
//      collectionView.collectionViewLayout = PinterestLayout()
        }
    }

    let items = SampleModel.demoData
}

extension Sample6CollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // セルの再利用
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell2.className, for: indexPath) as? MyCollectionViewCell2 else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.item]
        cell.configure(sampleModel: item)
        return cell
    }
}

extension Sample6CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
        let size = MyCollectionViewCell2.calcSize(width: collectionView.frame.width / 3, sampleModel: item)
        return size
    }
}

#Preview {
    Sample6CollectionViewController.makeFromStroryboard(name: "Sample6Collection", bundle: .module)!
}
