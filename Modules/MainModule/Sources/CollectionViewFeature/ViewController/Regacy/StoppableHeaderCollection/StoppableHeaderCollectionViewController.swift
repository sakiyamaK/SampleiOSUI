//
//  StoppableHeaderViewController.swift
//  SampleCollectionView
//
//  Created by  on 2021/10/21.
//

import UIKit

final class StoppableHeaderCollectionViewController: UIViewController {
    private let items = SampleModel.demoData

    var stoppableView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.heightAnchor.constraint(equalToConstant: 50),
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        ]
        NSLayoutConstraint.activate(constraints)
        return view
    }()

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(StoppableCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StoppableCollectionHeaderView.self))
            collectionView.register(MyCollectionViewCell2.nib, forCellWithReuseIdentifier: MyCollectionViewCell2.reuseIdentifier)
        }
    }
}

extension StoppableHeaderCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        print("\(#function)")
        return .init(width: collectionView.frame.width, height: 200)
    }
}

extension StoppableHeaderCollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell2.reuseIdentifier, for: indexPath) as! MyCollectionViewCell2
        let item = items[indexPath.item]
        cell.configure(sampleModel: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind _: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("\(#function)")
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StoppableCollectionHeaderView.self), for: indexPath) as! StoppableCollectionHeaderView
        header.configure(stoppableView: stoppableView, viewController: self)
        return header
    }
}
