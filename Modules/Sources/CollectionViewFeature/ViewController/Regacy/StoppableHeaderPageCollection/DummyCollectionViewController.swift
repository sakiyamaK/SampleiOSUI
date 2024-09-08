//
//  DummyCollectionViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2021/10/22.
//  Copyright © 2021 sakiyamaK. All rights reserved.
//

import UIKit

final class DummyCollectionViewController: UIViewController {
    var scrollView: UIScrollView { collectionView }

    var itemCount: Int = 100

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.className)
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }

    func reloadData(itemCount: Int) {
        self.itemCount = itemCount
        collectionView.reloadData()
    }
}

extension DummyCollectionViewController: UICollectionViewDelegate {}

extension DummyCollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return itemCount
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
