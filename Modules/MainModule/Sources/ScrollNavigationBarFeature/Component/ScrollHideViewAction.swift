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
    typealias ScrollAlogrithmClosure = ((
        _ moveView: UIView?,
        _ initContentOffset: CGPoint,
        _ defMoveViewOrigin: CGPoint,
        _ scrollStartContentOffset: CGPoint,
        _ defScrollStartContentOffset: CGPoint,
        _ scrollThresholdOffsetY: CGFloat,
        _ newOffset: CGPoint,
        _ oldOffset: CGPoint
    ) -> Void)
    private static let invalidOffset: CGPoint = .init(x: -1, y: -1)
    
    // デフォルトのOffset
    private var initContentOffset: CGPoint
    // scrollStartContentOffsetの初期値 ユーザの操作では絶対出ない座標にする
    private var defScrollStartContentOffset: CGPoint
    // スクロール開始Offset
    private var scrollStartContentOffset: CGPoint
    // ヘッダの座標を更新させるか判断する閾値
    private var scrollThresholdOffsetY: CGFloat
    // moveViewの初期値
    private var defMoveViewOrigin: CGPoint

    // ユーザが操作してスクロールするView
    private var scrollView: UIScrollView
    // scrollViewに合わせて動かしたいView
    private var moveView: UIView?
    
    private var scrollAlgorithm: ScrollAlogrithmClosure
    
    init(
        initContentOffset: CGPoint = ScrollHideViewAction.invalidOffset,
        defScrollStartContentOffset: CGPoint = ScrollHideViewAction.invalidOffset,
        scrollStartContentOffset: CGPoint = ScrollHideViewAction.invalidOffset,
        scrollThresholdOffsetY: CGFloat = 10,
        defMoveViewOrigin: CGPoint = ScrollHideViewAction.invalidOffset,
        scrollAlgorithm: @escaping ScrollAlogrithmClosure,
        scrollView: UIScrollView,
        moveView: UIView?) {
            self.initContentOffset = initContentOffset
            self.defScrollStartContentOffset = defScrollStartContentOffset
            self.scrollStartContentOffset = scrollStartContentOffset
            self.scrollThresholdOffsetY = scrollThresholdOffsetY
            self.defMoveViewOrigin = defMoveViewOrigin
            self.scrollAlgorithm = scrollAlgorithm
            self.scrollView = scrollView
            self.moveView = moveView

            super.init()
            self.setupContentOffsetObservation()
        }
    
    // contentOffsetの動きを監視
    private var contentOffsetObservation: NSKeyValueObservation?
    private func setupContentOffsetObservation() {
        contentOffsetObservation = scrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: {[weak self] scrollView, change in
            // isViewDidLayoutがtrueになる前に呼ばれると
            // contentOffsetの位置がまだ正しくないため、navigationBarが変な位置にくる
            
            guard
                let self,
                let oldOffset = change.oldValue,
                let newOffset = change.newValue
            else { return }
            
            self.scrollAlgorithm(
                moveView,
                initContentOffset,
                defMoveViewOrigin,
                scrollStartContentOffset,
                defScrollStartContentOffset,
                scrollThresholdOffsetY,
                newOffset,
                oldOffset
            )
        })
    }
    
    deinit {
        // 監視対象を開放
        contentOffsetObservation?.invalidate()
        contentOffsetObservation = nil
    }
    
    // 同名のViewControllerのメソッドで呼ぶ処理
    func viewDidLayoutSubviews() {
        // moveViewスクロールのための初期値を代入
        defMoveViewOrigin = moveView?.frame.origin ?? ScrollHideViewAction.invalidOffset
        initContentOffset = scrollView.contentOffset
    }
    
    func viewWillAppear() {
        self.scrollAlgorithm(
            moveView,
            initContentOffset,
            defMoveViewOrigin,
            scrollStartContentOffset,
            defScrollStartContentOffset,
            scrollThresholdOffsetY,
            scrollView.contentOffset,
            .zero
        )
    }

    func viewWillDisappear() {
    }
        
    // 同名のUIScrollViewDelegateのメソッドで呼ぶ処理たち
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollStartContentOffset = scrollView.contentOffset
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 慣性スクロールをする場合はまだスクロールが続くので処理しない
        if decelerate { return }
        // 初期値にする
        scrollStartContentOffset = defScrollStartContentOffset
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 慣性スクロールが終わった
        // 慣性スクロール自体していないと呼ばれないため注意
        // 初期値にする
        scrollStartContentOffset = defScrollStartContentOffset
    }
}

extension ScrollHideViewAction {
    static var scroll: ScrollAlogrithmClosure = {
        moveView,
        initContentOffset,
        defMoveViewOrigin,
        scrollStartContentOffset,
        defScrollStartContentOffset,
        scrollThresholdOffsetY,
        newOffset,
        oldOffset in
        
        let isValidatedScroll = defMoveViewOrigin != ScrollHideViewAction.invalidOffset &&
            initContentOffset != ScrollHideViewAction.invalidOffset
        
        guard let moveView, isValidatedScroll else {
            DLog()
            return
        }

        // scrollviewのframeでinitContentOffsetより下にいった時はmoveViewを初期値にする
        guard newOffset.y > initContentOffset.y else {
            DLog()
            moveView.setFrame(origin: defMoveViewOrigin)
            return
        }
                
        let scrollMoveAmount = abs(newOffset.y - scrollStartContentOffset.y)
        
        // ユーザタップ開始から一定(thresholdOffsetY)以上動かしたかどうか判断して
        // これ以降でmoveViewの移動処理をする
        guard scrollThresholdOffsetY < scrollMoveAmount  else {
            DLog()
            return
        }
        
        // 上にスクロールするとnewOffset.y > oldOffset.y となる、つまりyが増える
        // UIKitの座標系は下にいくほどYが増える
        // 反転させるためにoldOffsetからnewOffsetを引く
        let moveNavigationAmount = oldOffset.y - newOffset.y
        let moveOrigin = moveView.frame.offsetBy(dx: 0, dy: moveNavigationAmount).origin
        let newOrigin = defMoveViewOrigin.y > moveOrigin.y ? moveOrigin : defMoveViewOrigin
        DLog(newOrigin)
        moveView.setFrame(origin: newOrigin)
    }
    
    static var scrollNavigationBar: ScrollAlogrithmClosure = {
        moveView,
        initContentOffset,
        defMoveViewOrigin,
        scrollStartContentOffset,
        defScrollStartContentOffset,
        scrollThresholdOffsetY,
        newOffset,
        oldOffset in
            
        let isValidatedScroll = initContentOffset != ScrollHideViewAction.invalidOffset

        guard let moveView, isValidatedScroll else {
//            DLog()
            return
        }

        // scrollviewのframeでinitContentOffsetより下にいった時はmoveViewを初期値にする
        guard newOffset.y > initContentOffset.y else {
//            DLog()
            moveView.setBounds(origin: .zero)
            return
        }
                
        let scrollMoveAmount = abs(newOffset.y - scrollStartContentOffset.y)
        
        // ユーザタップ開始から一定(thresholdOffsetY)以上動かしたかどうか判断して
        // これ以降でmoveViewの移動処理をする
        guard scrollThresholdOffsetY < scrollMoveAmount  else {
//            DLog()
            return
        }
        
        // 上にスクロールするとnewOffset.y > oldOffset.y となる、つまりyが増える
        // UIKitの座標系は下にいくほどYが増える
        // boundsを動かす場合は反転する
        let moveNavigationAmount = newOffset.y - oldOffset.y
                
        let moveOrigin = moveView.bounds.offsetBy(dx: 0, dy: moveNavigationAmount).origin
        let newOrigin = moveOrigin.y > 0 ? moveOrigin : .zero
        
        moveView.setBounds(origin: newOrigin)
    }
}

extension UIView {
    func setFrame(origin: CGPoint) {
        frame = CGRect(
            origin: origin,
            size: bounds.size)
    }
    
    func setBounds(origin: CGPoint) {
        bounds = CGRect(
            origin: origin,
            size: bounds.size)
    }

}
