//
//  ObservationVIPERViewController.swift
//  
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit
import ObservableUIKit
import Utils

public protocol ObservationVIPERView: UIViewController {
}

public final class ObservationVIPERViewImpl: UIViewController, ObservationVIPERView {

    private var presenter: ObservationVIPERPresenter!
    func inject(presenter: ObservationVIPERPresenter) {
        self.presenter = presenter
    }

    private let layout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
    }()
    
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, User> { cell, indexPath, item in
        var config = UIListContentConfiguration.cell()
        config.text = item.id.name
        cell.contentConfiguration = config
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, User>!

    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: self.cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        collectionView.refreshControl = UIRefreshControl()
        return collectionView
    }()
    
    private var activityIndicatorView: UIActivityIndicatorView = .init(style: .large)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.applyArroundConstraint(equalTo: self.view)

        self.view.addSubview(collectionView)
        collectionView.applyArroundConstraint(equalTo: self.view)
        
        collectionView.observation(
            tracking: {[weak self] in
                self!.presenter.loading
            },
            onChange: { collectionView, loading in
                collectionView.isHidden = loading
            }
        ).observation(
            tracking: {[weak self] in
                self!.presenter.users
            }, onChange: {[weak self] _, users in
                var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
                snapshot.appendSections([0])
                snapshot.appendItems(users)
                self!.diffableDataSource.apply(snapshot, animatingDifferences: true)
            }
        )
        
        activityIndicatorView.observation(
            tracking: {[weak self] in
                self!.presenter.loading
            }, onChange: { activityIndicatorView, loading in
                if loading {
                    activityIndicatorView.startAnimating()
                } else {
                    activityIndicatorView.stopAnimating()
                }
            }
        )
        
        presenter.viewDidLoad()
    }
}

extension ObservationVIPERViewImpl: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.select(indexPath: indexPath)
        DLog()
    }
}

#Preview {
    ObservationVIPERRouterImpl.assembleModules()
}
