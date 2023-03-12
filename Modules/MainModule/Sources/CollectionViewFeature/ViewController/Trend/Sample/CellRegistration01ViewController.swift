//
//  CellRegistrationViewController.swift
//  
//
//  Created by sakiyamaK on 2023/03/10.
//

import DeclarativeUIKit
import UIKit
import Extensions

final class CellRegistration01ViewController: UIViewController {
    private let items = SampleModel.getDemoData(count: 20)
    
    private let listRegistration = UICollectionView.CellRegistration<UICollectionViewCell, SampleModel>() { cell, indexPath, sample in
        // デフォルトで用意されたオプションを設定できる
        var config = UIListContentConfiguration.cell()
        config.text = sample.title
        config.textProperties.color = indexPath.item%2 == 0 ? .systemRed : .systemBlue
        config.textProperties.font = UIFont.defaultFontBold(size: 20)
        config.secondaryText = indexPath.item%2 == 0 ? "hogehoge" : nil
        config.secondaryTextProperties.font = UIFont.defaultFontMedium(size: 20)

        // セルの設定をする
        cell.contentConfiguration = config
        cell.backgroundColor = indexPath.item%2 == 0 ? .systemBlue : .systemRed
        // backgroundViewで設定することもできる
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = indexPath.item%2 == 0 ? .systemBlue : .systemRed
//        cell.backgroundView = backgroundView
    }

    private weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        
        setupLayout()
    }
            
    @objc private func setupLayout() {
        
        view.backgroundColor = .white
        
        declarative {
            UICollectionView {
                // アイテム(セル)の大きさをグループの大きさと同じにする
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(1.0)
                )
                
                // アイテム設定に大きさを登録してインスタンスを作る
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                // 注意 サイズを.estimatedにするとcontentInsetsは効かない
                // https://komaji504.hateblo.jp/entry/2020/11/21/023856
                // https://developer.apple.com/documentation/uikit/nscollectionlayoutitem/3199084-contentinsets の Note
                item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                // グループサイズの横幅をコレクションビューの横幅と同じ、高さをSelf-Sizingにする
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(1.0)
                )
                // グループの水平設定に大きさとアイテムの種類を登録する
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                
                // セクションにグループを登録する
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
                
                // レイアウトにセクションを登録する
                let layout = UICollectionViewCompositionalLayout(section: section)
                return layout
            }
            .dataSource(self)
            .assign(to: &collectionView)
            .backgroundColor(.systemGray)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }
}

extension CellRegistration01ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DLog()
    }
}

extension CellRegistration01ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: listRegistration, for: indexPath, item: items[indexPath.item])
    }
}
