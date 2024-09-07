//
//  ScrollHideViewAction.swift
//
//
//  Created by sakiyamaK on 2024/04/03.
//

import UIKit
import Extensions

// scrollviewの動きに合わせてNavigationBar(もしくは画面上部にあるカスタムビュー)を隠す処理をするクラス
public final class ScrollHideViewAction: NSObject {

    private static let invalidOffset: CGPoint = .init(x: -1, y: -1)
    
    // デフォルトのOffset
    private var initContentOffset: CGPoint
    
    // ユーザが操作してスクロールするView
    private weak var scrollView: UIScrollView?
    // scrollViewに合わせて動かしたいView
    private weak var moveView: UIView?
    
    init(
        initContentOffset: CGPoint = ScrollHideViewAction.invalidOffset,
        scrollView: UIScrollView?,
        moveView: UIView?) {
            self.initContentOffset = initContentOffset
            self.scrollView = scrollView
            self.moveView = moveView

            super.init()
            self.setupContentOffsetObservation()
        }
    
    private var contentOffsetObservation: NSKeyValueObservation?
    private func setupContentOffsetObservation() {
        
        // contentOffsetの動きを監視
        contentOffsetObservation = scrollView?.observe(\.contentOffset, options: [.new, .old], changeHandler: {[weak self] scrollView, change in
            // isViewDidLayoutがtrueになる前に呼ばれると
            // contentOffsetの位置がまだ正しくないため、navigationBarが変な位置にくる
            
            guard
                let self,
                let oldOffset = change.oldValue,
                let newOffset = change.newValue
            else { return }
                        
            self.scroll(
                moveView,
                initContentOffset,
                newOffset,
                oldOffset,
                scrollView.isDecelerating
            )
        })
    }
    
    deinit {
        DLog()
        // 監視対象を開放
        contentOffsetObservation?.invalidate()
        contentOffsetObservation = nil
    }
    
    func resetPosition() {
        moveView?.setBounds(origin: .zero)
    }
    
    // 同名のViewControllerのメソッドで呼ぶ処理
    func viewDidLayoutSubviews() {
        initContentOffset = scrollView?.contentOffset ?? .zero
    }
    
    func viewWillAppear() {
        checkMovePosition()
    }
        
    // 同名のUIScrollViewDelegateのメソッドで呼ぶ処理たち
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 慣性スクロールをする場合はまだスクロールが続くので処理しない
        if decelerate { return }
        checkMovePosition()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 慣性スクロールが終わった
        // 慣性スクロール自体していないと呼ばれないため注意
        // 初期値にする
        checkMovePosition()
    }
}

private extension ScrollHideViewAction {
    var isValidatedScroll: Bool {
        initContentOffset != ScrollHideViewAction.invalidOffset
    }
    
    func scroll(_ moveView: UIView?,
                        _ initContentOffset: CGPoint,
                        _ newOffset: CGPoint,
                        _ oldOffset: CGPoint,
                        _ isDecelerating: Bool) {
            
        guard let moveView, isValidatedScroll else {
            return
        }

        // 引っ張りリロードで指を離した時に動かないようにさせるため
        guard newOffset.y >= initContentOffset.y else {
            moveView.setBounds(origin: .zero)
            return
        }
                                
        // boundsを変更するので+で上に移動する
        // 上にスクロールすると+
        let moveNavigationAmount = newOffset.y - oldOffset.y

        //
        if moveNavigationAmount < 0 && !isDecelerating {
            return
        }
        
        let moveOriginY = moveView.bounds.offsetBy(dx: 0, dy: moveNavigationAmount).origin.y
        let newOriginY = min(moveView.frame.maxY, max(0, moveOriginY))
        moveView.setBounds(origin: .init(x: 0, y: newOriginY))
    }
    
    func checkMovePosition() {
        guard let moveView, let scrollView else { return }
        if !isValidatedScroll {
            moveView.setBounds(origin: .zero)
            return
        }
        if !moveView.isHideTop, !moveView.isDefaultPosition {
            // 見えているけどちょっと隠れている
            if scrollView.contentOffset.y < 0 {
                // 画面の上部に空白がある
                moveView.setBounds(origin: .zero)
            } else {
                moveView.setBounds(origin: moveView.hideOrigin)
            }
        } else if moveView.isHideTop, scrollView.contentOffset.y < 0 {
            // 完全に隠れているが空白がある
            moveView.setBounds(origin: .zero)
        }
    }
}

extension UIView {
    var isHideTop: Bool {
        bounds.minY >= frame.maxY
    }
    // ぴったり0にならないことがある
    var isDefaultPosition: Bool {
        bounds.minY < 1.0
    }
    
    var hideOrigin: CGPoint {
        .init(x: 0, y: frame.maxY)
    }
    
    func setBounds(origin: CGPoint) {
        bounds = CGRect(
            origin: origin,
            size: bounds.size)
    }
}
