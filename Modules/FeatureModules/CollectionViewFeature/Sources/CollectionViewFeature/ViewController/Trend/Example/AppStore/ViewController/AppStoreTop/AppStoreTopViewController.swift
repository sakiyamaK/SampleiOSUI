//
//  AppStoreTopViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/4/7.
//

import UIKit

final class AppStoreTopViewController: UIViewController {
    private var items: [SampleImageModel2] = []

    private lazy var collectionView: UICollectionView! = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AppStoreFullImageCell.self, forCellWithReuseIdentifier: AppStoreFullImageCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        ])

        SampleImageModel2.load(times: 3) { [unowned self] items in
            self.items = items
            self.collectionView.reloadData()
        }
    }
}

extension AppStoreTopViewController: AppStoreFullImageViewDelegate {
    func toucheStart() {}

    func toucheEnd(sampleModel: SampleImageModel2, heroId: String?) {
        self.show(next: AppStoreDetailViewController.makeFromStoryboard(sampleModel: sampleModel, heroId: heroId), animated: true)
    }

    func tapCloseButton() {}
}

private extension AppStoreTopViewController {
    func updateLayout() {
        collectionView.collectionViewLayout = layout
        collectionView.alpha = 0.0
        collectionView.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.alpha = 1.0
        })
    }

    var layout: UICollectionViewLayout {
        UICollectionViewCompositionalLayout { section, environment -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 0)
            let height = 1.3 * environment.container.effectiveContentSize.width
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(height)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
            return section
        }
    }
}

extension AppStoreTopViewController: UICollectionViewDelegate {}

extension AppStoreTopViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppStoreFullImageCell.reuseId, for: indexPath) as! AppStoreFullImageCell
        let item = items[indexPath.item]
        cell.configure(sample: item)
        cell.delegate = self
        return cell
    }
}

#Preview {
    AppStoreTopViewController()
}
