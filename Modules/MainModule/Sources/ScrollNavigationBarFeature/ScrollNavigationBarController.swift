//
//  ScrollNavigationBarController.swift
//  
//
//  Created by sakiyamaK on 2023/08/09.
//

import UIKit
import Extensions

// scrollviewの動きに合わせてNavigationBar(もしくは画面上部にあるカスタムビュー)を隠す処理をするクラス
final class ScrollHideNavigationBarAction: NSObject {
    private static let invalidOffset: CGPoint = .init(x: -1, y: -1)
    
    // デフォルトのOffset
    private var initContentOffset: CGPoint
    // レイアウトを組み終わったかどうか判断するフラグ
    private var isViewDidLayout: Bool
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
    private var moveView: UIView
    
    init(
        initContentOffset: CGPoint = ScrollHideNavigationBarAction.invalidOffset,
        isViewDidLayout: Bool = false,
        defScrollStartContentOffset: CGPoint = ScrollHideNavigationBarAction.invalidOffset,
        scrollStartContentOffset: CGPoint = ScrollHideNavigationBarAction.invalidOffset,
        scrollThresholdOffsetY: CGFloat = 10,
        scrollView: UIScrollView,
        moveView: UIView) {
            self.initContentOffset = initContentOffset
            self.isViewDidLayout = isViewDidLayout
            self.defScrollStartContentOffset = defScrollStartContentOffset
            self.scrollStartContentOffset = scrollStartContentOffset
            self.scrollThresholdOffsetY = scrollThresholdOffsetY
            self.scrollView = scrollView
            self.moveView = moveView
            defMoveViewOrigin = moveView.bounds.origin
            
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
                isViewDidLayout,
                // 上にスクロールするとnewOffset.y > oldOffset.y となる
                let oldOffset = change.oldValue,
                let newOffset = change.newValue
            else { return }
            
            // scrollviewのbouncesでinitContentOffsetより下にいった時はmoveViewを初期値にする
            guard newOffset.y > initContentOffset.y else {
                resetMoveView()
                return
            }
            
            //スクロール開始時の座標が初期値ではない
            let isNotDefScrollStart =
            scrollStartContentOffset.x != defScrollStartContentOffset.x ||
            scrollStartContentOffset.y != defScrollStartContentOffset.y
            
            guard isNotDefScrollStart else { return }
            
            let scrollMoveAmount = abs(newOffset.y - scrollStartContentOffset.y)
            
            // ユーザたっぷ開始から一定(thresholdOffsetY)以上動かしたかどうか判断して
            // これ以降でnavigationBarの移動処理をする
            guard scrollThresholdOffsetY < scrollMoveAmount  else { return }
            
            let moveNavtaionAmount = newOffset.y - oldOffset.y
            
            let tmpY = moveView.bounds.minY + moveNavtaionAmount
            
            // UIKitの座標系は下にいくほどYが増える(defContentOffset.y)
            // CoreGraphics(CGRect)などは上にいくほどYが増える(tmpY)
            // そのため上限下限の計算時に反転させる
            let minMaxNextNavigationY = min(-initContentOffset.y, max(0, tmpY))
            
            // navigationBarのy座標を更新
            // +で上方向に動く
            moveView.bounds = CGRect(
                origin: .init(x: moveView.bounds.origin.x, y: minMaxNextNavigationY),
                size: moveView.bounds.size)
        })
    }
    
    deinit {
        // 監視対象を開放
        contentOffsetObservation?.invalidate()
        contentOffsetObservation = nil
    }
    
    private func resetMoveView() {
        moveView.bounds = CGRect(
            origin: defMoveViewOrigin,
            size: moveView.bounds.size)
    }
    
    // 同名のViewControllerのメソッドで呼ぶ処理
    func viewDidLayoutSubviews() {
        isViewDidLayout = true
        // moveViewスクロールのための初期値を代入
        initContentOffset = scrollView.contentOffset
    }
    func viewWillDisappear() {
        resetMoveView()
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

// ***** 使う側
public class ScrollNavigationBarController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let registration = UICollectionView.CellRegistration<UICollectionViewCell, String>() { cell, indexPath, name in
        var config = UIListContentConfiguration.cell()
        config.text = name
        cell.contentConfiguration = config
        cell.backgroundColor = .systemYellow
    }
    
    //************ [navigationBarを移動させるためのクラスのインスタンス]
    private lazy var scrollHideNavigationBarAction: ScrollHideNavigationBarAction = .init(
        scrollView: collectionView,
        moveView: self.navigationController!.navigationBar
    )
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //************ [1]
        scrollHideNavigationBarAction.viewWillDisappear()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //************ [2]
        scrollHideNavigationBarAction.viewDidLayoutSubviews()
    }
}

extension ScrollNavigationBarController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //************ [3]
        scrollHideNavigationBarAction.scrollViewWillBeginDragging(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //************ [4]
        scrollHideNavigationBarAction.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //************ [5]
        scrollHideNavigationBarAction.scrollViewDidEndDecelerating(scrollView)
    }
}

extension ScrollNavigationBarController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ScrollNavigationBarController()
        self.show(next: vc, animated: true)
    }
}

extension ScrollNavigationBarController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: indexPath.item.description)
    }
}
