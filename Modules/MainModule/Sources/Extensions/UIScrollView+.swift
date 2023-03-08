//
//  UICollectionView.swift
//  SampleCompositonalLayout
//
//  Created by sakiyamaK on 2021/06/27.
//

import UIKit

public extension UIScrollView {
    var reachedBottom: Bool { reachedBottom() }

    func reachedBottom(ratio: CGFloat = 0.8) -> Bool {
        // 見えてる範囲の高さを取得
        let visibleHeight = frame.height - contentInset.top - contentInset.bottom
        // スクロール量の閾値
        let threshold = max(0.0, contentSize.height - visibleHeight) * ratio
        // 現在のスクロールのy座標をInsetの設定も考慮して取得
        let y = contentOffset.y + contentInset.top
        // y座標が閾値より下にあるか判定
        return y > threshold
    }
}
