//
//  CellRegistrationViewController.swift
//  
//
//  Created by sakiyamaK on 2023/03/10.
//

import DeclarativeUIKit
import UIKit
import Extensions
import IQKeyboardManagerSwift

final class LoadingView: UIView {
    
}

final class CellRegistration01ViewController: UIViewController {
    private let items = SampleModel.getDemoData(count: 8)
    
    private let listRegistration = UICollectionView.CellRegistration<UICollectionViewCell, SampleModel>() { cell, indexPath, sample in
        // デフォルトで用意されたオプションを設定できる
        var config = UIListContentConfiguration.cell()
        let image = UIImage(systemName: "square.and.arrow.up")!
        config.image = image
        config.imageProperties.maximumSize = image.size
        config.imageProperties.reservedLayoutSize = image.size
        // セルの設定をする
        cell.contentConfiguration = config
        cell.backgroundColor = .systemRed.withAlphaComponent(1.0)
    }
    
    private weak var collectionView: UICollectionView!
    private weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UIStackView.vertical {
                UISearchBar(assign: &searchBar)
                    .searchBarStyle(.minimal)
                    .placeholder("placeholderだよおおん")
                    .barTintColor(.white)
                    .delegate(self)
                                
                UICollectionView {
                    // アイテム(セル)の大きさをグループの大きさと同じにする
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100)
                    )
                    
                    // アイテム設定に大きさを登録してインスタンスを作る
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    // 注意 サイズを.estimatedにするとcontentInsetsは効かない
                    // https://komaji504.hateblo.jp/entry/2020/11/21/023856
                    // https://developer.apple.com/documentation/uikit/nscollectionlayoutitem/3199084-contentinsets の Note
                    item.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
                    
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
                .delegate(self)
                .assign(to: &collectionView)
                .backgroundColor(.systemGray)
            }
        }
        collectionView.reloadData()
    }
}

extension CellRegistration01ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.returnKeyType = UIReturnKeyType.done
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension CellRegistration01ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
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

#Preview {
    CellRegistration01ViewController()
}
