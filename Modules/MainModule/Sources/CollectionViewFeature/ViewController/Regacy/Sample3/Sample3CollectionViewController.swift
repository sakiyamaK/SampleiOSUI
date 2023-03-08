//
//  Sample3CollectionViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/07.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

// Cellごとにで大きさを変える

import UIKit

final class Sample3CollectionViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.reuseIdentifier)
        }
    }
}

extension Sample3CollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        // セクションごとのセルの数
        // この例ではセクション数の指定がないので1セクションでそこに100セルある
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // セルの再利用
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reuseIdentifier, for: indexPath)
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

/*
 UICollectionViewDelegateFlowLayoutを継承して大きさを変えるメソッドを実装する
 indexPathごとに呼ばれるのでCellごとに大きさを変えることができる
 */
extension Sample3CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }

        let num: CGFloat = 3
        let a = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right -
            (num - 1) * flowLayout.minimumInteritemSpacing

        let width = CGFloat(Int(a / num))
        let height = CGFloat((indexPath.item % 5 + 1) * 50)

        print(collectionView.frame.width)
        print(flowLayout.minimumInteritemSpacing)
        print(width)

        return CGSize(width: width, height: height)
    }
}
