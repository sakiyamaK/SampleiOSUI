//
//  SampleNSKeyValueObservationViewController.swift
//  
//
//  Created by sakiyamaK on 2023/10/07.
//

import UIKit
import DeclarativeUIKit
import Extensions
import Components

public final class SampleNSKeyValueObservationViewController: UIViewController {
    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        
        setupLayout()
    }
    
    let registration = UICollectionView.CellRegistration<UICollectionViewCell, String>() { cell, indexPath, name in
        // デフォルトで用意されたオプションを設定できる
        var config = UIListContentConfiguration.cell()
        config.text = name
        config.secondaryText = "text"
        // セルの設定をする
        cell.contentConfiguration = config
        cell.backgroundColor = .yellow
    }
    
    // contentOffsetの動きを監視
    private var contentOffsetObservation: NSKeyValueObservation?
    // デフォルトのOffset
    private var defContentOffset: CGPoint = .zero
    // レイアウトを組み終わったかどうか判断するフラグ
    private var isViewDidLayout: Bool = false

    private weak var collectionView: UICollectionView!
    var navigationBar: UINavigationBar { self.navigationController!.navigationBar }
    
    @objc func setupLayout() {
        self
            .applyView({
                $0.backgroundColor(.white)
            })
            .declarative(safeAreas: .init(top: false)) {
                UICollectionView {
                    UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
                }
                .dataSource(self)
                .delegate(self)
                .assign(to: &collectionView)
            }
        
        // contentOffsetの変更を監視
        contentOffsetObservation = collectionView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] scrollView, change in
            guard let self = self, self.isViewDidLayout, let newOffset = change.newValue else { return }
            let move = defContentOffset.y - newOffset.y
            let newY = max(defContentOffset.y, min(0, move))
            navigationBar.bounds = CGRect(
                x: navigationBar.bounds.origin.x,
                y: -newY,
                width: navigationBar.bounds.width,
                height: navigationBar.bounds.height)
        })
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        isViewDidLayout = true
        // navigationbarスクロールのための初期値を代入
        defContentOffset = collectionView.contentOffset
    }
    
    deinit {
        // 監視対象を開放
        contentOffsetObservation?.invalidate()
    }
}

extension SampleNSKeyValueObservationViewController: UICollectionViewDelegate {
    
}

extension SampleNSKeyValueObservationViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: indexPath.item.description)
    }
}
