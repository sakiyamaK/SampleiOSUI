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
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, String>() { cell, indexPath, name in
        var config = UIListContentConfiguration.cell()
        config.text = name
        cell.contentConfiguration = config
        cell.backgroundColor = .systemYellow
    }
    
    private var collectionView: UICollectionView!
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
        DLog()
        scrollHideViewActions.forEach { $0.viewWillAppear() }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //************ [1]
        DLog()
        scrollHideViewActions.forEach { $0.viewWillDisappear() }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //************ [2]
        DLog()
        setupScrollView?(collectionView)
        scrollHideViewActions.forEach { $0.viewDidLayoutSubviews() }
    }
}

extension ScrollNavigationBarPagingViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //************ [3]
        scrollHideViewActions.forEach { $0.scrollViewWillBeginDragging(scrollView) }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //************ [4]
        scrollHideViewActions.forEach { $0.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate) }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //************ [5]
        scrollHideViewActions.forEach { $0.scrollViewDidEndDecelerating(scrollView) }
    }
}

extension ScrollNavigationBarPagingViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ScrollNavigationBarPagingViewController()
        self.show(next: vc, animated: true)
    }
}

extension ScrollNavigationBarPagingViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: indexPath.item.description)
    }
}
