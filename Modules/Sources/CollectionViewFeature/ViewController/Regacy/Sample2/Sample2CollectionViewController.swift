//
//  Sample2CollectionViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/07.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

// UICollectionViewFlowLayoutを使ったレイアウトの変更

import UIKit

final class Sample2CollectionViewController: UIViewController {
    typealias HeaderView = UICollectionReusableView
    private let HeaderID = "header"
    typealias FooterView = UICollectionReusableView
    private let FooterID = "footer"

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.className)

            // ヘッダとフッダの登録
            collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderID)
            collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterID)

            // UICollectionViewFlowLayoutでセルのレイアウトの定義を決める
            /*
             色々コメントアウトを外して表示がどうなるか確かめよう
             */
            let layout = UICollectionViewFlowLayout()
            do { // 特に意味はないけどここからlayoutの設定だと見やすいようにdoで囲った
                // (*1) セルのサイズ
                layout.itemSize = CGSize(width: 100, height: 100)
                // (*2) セル同士の間隔
                // ただし、UICollectionViewLayoutは行の最後にセルが収まるように横の間隔を決めるため
                // 「あくまで最低でもこれぐらい開けてください」という指定
                // 縦同士のセルはこの分だけ開く (垂直方向のスクロールの場合)
                layout.minimumLineSpacing = 1
                // (*3) セルの配置位置の余白を設定する
                layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                // (*4) ヘッダとフッダの高さ
                layout.headerReferenceSize = CGSize(width: 0, height: 300)
                layout.footerReferenceSize = CGSize(width: 100, height: 100)
            }
            collectionView.collectionViewLayout = layout

            // CollectionViewではないが親クラスのScrollViewに備わっている機能
            do {
                collectionView.contentInset = UIEdgeInsets(top: 100, left: 10, bottom: 100, right: 10)
                // レイアウトが決まってからじゃないとoffsetの位置は決めようがないので3秒後に動かしている
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//          self.collectionView.contentOffset = CGPoint(x: -10, y: 200)
                    // アニメーションさせたいならこのメソッド
                    self.collectionView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
                }
            }
        }
    }
}

extension Sample2CollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        // セクションごとのセルの数
        // この例ではセクション数の指定がないので1セクションでそこに100セルある
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView.contentOffset)
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderID, for: indexPath)
            header.backgroundColor = .yellow
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterID, for: indexPath)
            footer.backgroundColor = .purple
            return footer
        default:
            return UICollectionReusableView()
        }
    }
}

#Preview {
    Sample2CollectionViewController.makeFromStroryboard(name: "Sample2Collection", bundle: .module)!
}
