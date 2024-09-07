//
//  ScrollNavigationBarPagingViewController.swift
//
//
//  Created by sakiyamaK on 2023/08/09.
//

import UIKit
import DeclarativeUIKit
import Extensions

public class ScrollNavigationBarPagingViewController: UIViewController, ScrollNavigationTabBarPagingViewControllerProtocol {
    deinit {
        DLog()
    }
    private var cellCount = 0
    private let addCellCount = 100
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, String>() { cell, indexPath, name in
        var config = UIListContentConfiguration.cell()
        config.text = name
        cell.contentConfiguration = config
        cell.backgroundColor = .systemYellow
    }
    
    private weak var collectionView: UICollectionView!
    public var setupScrollView: ((UIScrollView) -> Void)?
    private(set) public var scrollHideViewActions: [ScrollHideViewAction] = []
    public var setScrollHideViewActions: ((UIScrollView) -> [ScrollHideViewAction])?
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.applyView({ $0.backgroundColor(.white) })
            .declarative(safeAreas: .init(top: false)) {
                UICollectionView(UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain)))
                    .delegate(self)
                    .dataSource(self)
                    .assign(to: &collectionView)
            }

        scrollHideViewActions = setScrollHideViewActions?(collectionView) ?? []
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollHideViewActions.forEach { $0.viewWillAppear() }
    }
        
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DLog()
        setupScrollView?(collectionView)
        scrollHideViewActions.forEach { $0.viewDidLayoutSubviews() }
    }
}

extension ScrollNavigationBarPagingViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // MEMO: UIRefreshControl表示時は以降の処理を行わない(※APIリクエストの状態とRefreshControlの状態を連動させている点がポイント)
        if let refreshControl = scrollView.refreshControl, refreshControl.isRefreshing {
            return
        }
        
        // MEMO: UIScrollViewが一番下の状態に達した時にAPIリクエストを実行する
        if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height {
            collectionView.reloadData()
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollHideViewActions.forEach { $0.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate) }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollHideViewActions.forEach { $0.scrollViewDidEndDecelerating(scrollView) }
    }
}

extension ScrollNavigationBarPagingViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        scrollHideViewActions.forEach { $0.resetPosition() }

        let vc = ScrollNavigationBarPagingViewController()
        self.show(next: vc, animated: true)
    }
}

extension ScrollNavigationBarPagingViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellCount += addCellCount
        return cellCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: indexPath.item.description)
    }
}

#Preview {
    ScrollNavigationBarPagingViewController()
}
