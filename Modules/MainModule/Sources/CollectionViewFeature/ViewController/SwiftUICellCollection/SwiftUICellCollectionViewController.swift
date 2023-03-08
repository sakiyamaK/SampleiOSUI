//
//  SwiftUICellCollectionViewController.swift
//  SampleCollectionView
//
//  Created by  on 2021/11/3.
//

import UIKit

final class SwiftUICellCollectionViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {}
    }
}

extension SwiftUICellCollectionViewController: UICollectionViewDelegate {}

extension SwiftUICellCollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        0
    }

    func collectionView(_: UICollectionView, cellForItemAt _: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
