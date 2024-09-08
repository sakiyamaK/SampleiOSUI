//
//  SampleHeroDetailViewContreoller.swift
//
//
//  Created by sakiyamaK on 2024/04/30.
//

import UIKit
import DeclarativeUIKit
import Hero
import Extensions
//import ResourceFeature

public final class SampleHeroDetailViewContreoller: UIViewController {
    enum Section: Int, CaseIterable {
        case header = 0, cell
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    struct Delegate {
        var tap: (() -> Void)
    }
    
    var delegate: Delegate?

    public override func viewDidLoad() {
        super.viewDidLoad()

        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Int>() { cell, indexPath, index in
            // デフォルトで用意されたオプションを設定できる
            var config = UIListContentConfiguration.cell()
            let image = UIImage(systemName: "home")
            config.image = image
            cell.contentConfiguration = config
            cell.backgroundColor = .clear
        }

        let listRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Int>() { cell, indexPath, index in
            // デフォルトで用意されたオプションを設定できる
            var config = UIListContentConfiguration.cell()
            // セルの設定をする
            cell.contentConfiguration = config
            cell.backgroundColor = .systemRed
        }


        self.declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout {
                    sectionIndex,
                    enviroment in
                    guard let section = Section(rawValue: sectionIndex) else { fatalError() }
                    switch section {
                    case .header:
                        // 最初のセクションのレイアウト
                        let itemSize = NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(
                                1.0
                            ),
                            heightDimension: .fractionalWidth(
                                1.0
                            )
                        )
                        return NSCollectionLayoutSection(
                            group: NSCollectionLayoutGroup.horizontal(
                                layoutSize: itemSize,
                                subitems: [NSCollectionLayoutItem(
                                    layoutSize: itemSize
                                )]
                            )
                        )
                    case .cell:
                        // 2番目のセクションのレイアウト
                        let itemSize = NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(
                                1.0/3
                            ),
                            heightDimension: .fractionalWidth(
                                1.0/3
                            )
                        )
                        let group = NSCollectionLayoutGroup.horizontal(
                            layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(
                                    1.0
                                ),
                                heightDimension: itemSize.heightDimension
                            ),
                            subitems: [NSCollectionLayoutItem(
                                layoutSize: itemSize
                            )]
                        )
                        group.interItemSpacing = .fixed(
                            10
                        ) // セル間のスペース
                        let section = NSCollectionLayoutSection(
                            group: group
                        )
                        section.interGroupSpacing = 10 // グループ間のスペース
                        section.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
                        return section
                    }
                }
            }
            .apply {[weak self] in
                guard let self else { return }
                // データソースを定義
                dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: $0) { (collectionView: UICollectionView, indexPath: IndexPath, index: Int) -> UICollectionViewCell? in
                    guard let section = Section(rawValue: indexPath.section) else { fatalError() }
                    return switch section {
                    case .header:
                        collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: indexPath.item)
                    case .cell:
                        collectionView.dequeueConfiguredReusableCell(using: listRegistration, for: indexPath, item: indexPath.item)
                    }

                }
            }
            .delegate(self)
        }
        .applyNavigationItem {
            $0.title = "詳細だよお"
        }.applyView {
            $0.backgroundColor(.systemGray)
        }
                
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.header, .cell])
        snapshot.appendItems([21], toSection: .header)
        snapshot.appendItems(Array(0...20), toSection: .cell)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension SampleHeroDetailViewContreoller: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.tap()
    }
}

#Preview {
    SampleHeroDetailViewContreoller()
}
