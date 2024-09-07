//
//  SampleHeroViewContreoller.swift
//  
//
//  Created by sakiyamaK on 2024/04/30.
//

import UIKit
import DeclarativeUIKit
import Hero
import Extensions
//import ResourceFeature

public final class SampleHeroViewContreoller: UIViewController {
    enum Section: CaseIterable {
        case main
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
     
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let listRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Int>() { cell, indexPath, index in
            DLog(index)
            // デフォルトで用意されたオプションを設定できる
            var config = UIListContentConfiguration.cell()
//            let image = R.image.lufy()
//            config.image = image
            config.imageProperties.maximumSize = .init(width: 200, height: 200)
            config.imageProperties.reservedLayoutSize = .init(width: 200, height: 200)
            // セルの設定をする
            cell.contentConfiguration = config
            cell.backgroundColor = .systemRed.withAlphaComponent(0.5)
        }


        self.declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
            }
            .apply {[weak self] in
                guard let self else { return }
                // データソースを定義
                dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: $0) { (collectionView: UICollectionView, indexPath: IndexPath, index: Int) -> UICollectionViewCell? in
                    collectionView.dequeueConfiguredReusableCell(using: listRegistration, for: indexPath, item: indexPath.item)

                }
            }
            .delegate(self)
        }
        .applyNavigationItem {[weak self] in
            guard let self else { return }
            $0.title = "タイトルだよ"
        }.applyView {
            $0.backgroundColor(.systemGray)
        }
                
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0...20))
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension SampleHeroViewContreoller: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SampleHeroDetailViewContreoller()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

#Preview {
    SampleHeroViewContreoller()
}
