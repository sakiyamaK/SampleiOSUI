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
        _ newOffset: CGPoint,
        _ oldOffset: CGPoint
    ) -> Void)
    private static let invalidOffset: CGPoint = .init(x: -1, y: -1)
    
    // デフォルトのOffset
    private var initContentOffset: CGPoint

    // ユーザが操作してスクロールするView
    private var scrollView: UIScrollView
    // scrollViewに合わせて動かしたいView
    private var moveView: UIView?
    
    private var scrollAlgorithm: ScrollAlogrithmClosure
 
    init(
        initContentOffset: CGPoint = ScrollHideViewAction.invalidOffset,
        scrollAlgorithm: @escaping ScrollAlogrithmClosure = ScrollHideViewAction.scroll,
        scrollView: UIScrollView,
        moveView: UIView?) {
            self.initContentOffset = initContentOffset
            self.scrollAlgorithm = scrollAlgorithm
            self.scrollView = scrollView
            self.moveView = moveView

            super.init()
            self.setupContentOffsetObservation()
        }
    
    private var contentOffsetObservation: NSKeyValueObservation?
    private func setupContentOffsetObservation() {
        
        // contentOffsetの動きを監視
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
        initContentOffset = scrollView.contentOffset
    }
    
    func viewWillAppear() {
        self.scrollAlgorithm(
            moveView,
            initContentOffset,
            scrollView.contentOffset,
            .zero
        )
    }

    func viewWillDisappear() {
    }
        
    // 同名のUIScrollViewDelegateのメソッドで呼ぶ処理たち
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 慣性スクロールをする場合はまだスクロールが続くので処理しない
        if decelerate { return }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 慣性スクロールが終わった
        // 慣性スクロール自体していないと呼ばれないため注意
        // 初期値にする
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard let moveView, -moveView.bounds.minY < moveView.frame.maxY else { return }
        
        moveView.setBounds(origin: CGPoint(x: 0, y: moveView.frame.maxY))
    }
}

extension ScrollHideViewAction {
    
    static var scroll: ScrollAlogrithmClosure = {
        moveView,
        initContentOffset,
        newOffset,
        oldOffset
        in
            
        let isValidatedScroll = initContentOffset != ScrollHideViewAction.invalidOffset

        guard let moveView, isValidatedScroll else {
            return
        }

        guard newOffset.y >= initContentOffset.y else {
            moveView.setBounds(origin: .zero)
            return
        }
                
        // boundsを変更するので+で上に移動する
        // 上にスクロールするとoffsetの値は小さくなる
        let moveNavigationAmount = newOffset.y - oldOffset.y
        DLog(moveNavigationAmount)
        let moveOrigin = moveView.bounds.offsetBy(dx: 0, dy: moveNavigationAmount).origin
        DLog(moveOrigin)
        let newOrigin = moveOrigin.y > 0 ? moveOrigin : .zero
        DLog(newOrigin)
        moveView.setBounds(origin: newOrigin)
    }
}

extension UIView {
    func setBounds(origin: CGPoint) {
        bounds = CGRect(
            origin: origin,
            size: bounds.size)
    }
}
