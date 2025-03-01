//
//  SampleCollectionViewController.swift
//
//
//  Created by sakiyamaK on 2024/06/28.
//

import DeclarativeUIKit
import UIKit
import Extensions
import SwiftyAttributes

public class SampleCollectionViewController: UIViewController {

    deinit { DLog() }

    private var items: [Int] = Array(0...100)
//        .compactMap({ v in
//        v
//    })

    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!

    private let scrollEdgeNavBarAppearance: UINavigationBarAppearance = {

        let buttonAppearance: UIBarButtonItemAppearance = {
            var appearance = UIBarButtonItemAppearance()
            appearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.systemRed,
                .font: UIFont.boldSystemFont(ofSize: 16)
            ]
            return appearance
        }()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemCyan
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.systemBrown
        ]
        appearance.buttonAppearance = buttonAppearance
        return appearance
    }()


    private let standardNavBarAppearance: UINavigationBarAppearance = {

        let buttonAppearance: UIBarButtonItemAppearance = {
            var appearance = UIBarButtonItemAppearance()
            appearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.systemBlue,
                .font: UIFont.boldSystemFont(ofSize: 32)
            ]
            return appearance
        }()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.systemGray
        ]
        appearance.buttonAppearance = buttonAppearance
        return appearance
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = standardNavBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeNavBarAppearance

        self.applyView({
            $0.backgroundColor(.systemBackground)
        }).applyNavigationItem(
            { navigationItem in
                navigationItem.title = "Sample"
//                navigationItem.largeTitleDisplayMode = .always
                
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain).primaryAction(
                    .init(
                        title: "次へ",
                        handler: { [weak self] _ in
                            self?.navigationController?.pushViewController(
                                SampleCollectionViewController(),
                                animated: true
                            )
                        })
                )
        }).declarative(layoutGuides: .init(all: .normal)) {
            UICollectionView {
                UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                    let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
                    return section
                }
            }
            .apply({ collectionView in
                let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Void> { cell, indexPath, item in
                    var configuration = cell.defaultContentConfiguration()
                    configuration.text = "\(indexPath.item)です"
                    configuration.image = UIImage(systemName: "square.and.arrow.up")
                    cell.contentConfiguration = configuration
                }

                self.dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
                    switch indexPath.section {
                    default:
                        collectionView.dequeueConfiguredReusableCell(
                            using: cellRegistration,
                            for: indexPath,
                            item: ()
                        )
                    }
                }

                var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
                snapshot.appendSections([0])
                snapshot.appendItems(
                    self.items.compactMap({ $0.description }),
                    toSection: 0
                )
                self.dataSource.apply(snapshot)
            })
        }
    }
}

#Preview {
    SampleCollectionViewController().withNavigationController
}
