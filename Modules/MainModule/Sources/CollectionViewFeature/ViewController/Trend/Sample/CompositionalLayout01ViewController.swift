//
//  CompositionalLayout01ViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/3/21.
//

import DeclarativeUIKit
import UIKit
import Extensions

final class CompositionalLayout01ViewController: UIViewController {
    private let items = SampleModel02.samples

    override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        
        setupLayout()
    }
    
    @objc func setupLayout() {
        view.backgroundColor = .white

        declarative {
            UICollectionView {
                
                // アイテム(セル)の大きさをグループの大きさと同じにする
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )

                // アイテム設定に大きさを登録してインスタンスを作る
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)

                // グループサイズの横幅をコレクションビューの横幅と同じ、高さを44にる
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(44)
                )
                // グループの水平設定に大きさとアイテムの種類を登録する
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                // セクションにグループを登録する
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)

                // レイアウトにセクションを登録する
                let layout = UICollectionViewCompositionalLayout(section: section)
                return layout
            }
            .registerCellClass(UICollectionViewCell01.self, forCellWithReuseIdentifier: UICollectionViewCell01.reuseId)
            .backgroundColor(.systemGray)
            .dataSource(self)
            .delegate(self)
        }
    }
}

extension CompositionalLayout01ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DLog()
    }
}

extension CompositionalLayout01ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell01.reuseId, for: indexPath) as! UICollectionViewCell01
        cell.configure(sample: items[indexPath.item])
        return cell
    }
}
