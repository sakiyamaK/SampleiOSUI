//
//  Sample1CollectionViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/06.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

// UICollectionViewを使った最小実装

import UIKit

final class Sample1CollectionViewController: UIViewController {
    @IBOutlet private(set) var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.className)
        }
    }
}

extension Sample1CollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        // セクションごとのセルの数
        // この例ではセクション数の指定がないので1セクションでそこに100セルある
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // セルの再利用
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.className, for: indexPath)
        // indexPathで背景色を変えてみた
        switch indexPath.item % 5 {
        case 0:
            cell.backgroundColor = .red
        case 1:
            cell.backgroundColor = .green
        case 2:
            cell.backgroundColor = .blue
        case 3:
            cell.backgroundColor = .black
        case 4:
            cell.backgroundColor = .brown
        default:
            break
        }
        return cell
    }
}

#Preview {
    Sample1CollectionViewController.makeFromStroryboard(name: "Sample1Collection", bundle: .module)!
}
