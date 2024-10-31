//
//  UserList3ViewController.swift
//  
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit
import Utils
import ObservableUIKit
import Kingfisher

public protocol UserList3View: UIView {
    func setup(with presenter: UserList3Presenter)
}

public final class UserList3ViewImpl: UIView, UserList3View {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { print("\(Self.self) deinit") }

    private var presenter: UserList3Presenter!
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.refreshControl = UIRefreshControl()
        
        collectionView.refreshControl?.addAction(.init(handler: {[weak self] _ in
            self!.presenter.changeValueRefreshControl()
        }), for: .valueChanged)
        return collectionView
    }()
    
    private var activityIndicatorView: UIActivityIndicatorView = .init(style: .large)
    
    init() {
        super.init(frame: .zero)
    }
        
    public func setup(with presenter: UserList3Presenter) {
        self.presenter = presenter
        self.setupUI()
        self.setupDataSource()
        self.setupObservation()
    }

    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(activityIndicatorView)
        activityIndicatorView.applyArroundConstraint(equalTo: self)

        self.addSubview(collectionView)
        collectionView.applyArroundConstraint(equalTo: self)
    }
    
    private func setupObservation() {
        collectionView
            .observation(
                tracking: {[weak self] in
                    self!.presenter.initilalLoading
                },
                onChange: { collectionView, loading in
                    collectionView.isHidden = loading
                }
            ).observation(
                tracking: {[weak self] in
                    self!.presenter.refreshLoading
                }, onChange: { collectionView, refreshLoading in
                    collectionView.refreshControl?.endRefreshing()
                }
            ).observation(
                tracking: {[weak self] in
                    self!.presenter.users
                }, onChange: {[weak self] _, users in
                    
                    var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
                    snapshot.appendSections([0])
                    snapshot.appendItems(users)
                    self!.diffableDataSource.apply(snapshot, animatingDifferences: false)
                }
            )
        
        activityIndicatorView
            .observation(
                tracking: {[weak self] in
                    self!.presenter.initilalLoading
                }, onChange: { activityIndicatorView, loading in
                    if loading {
                        activityIndicatorView.startAnimating()
                    } else {
                        activityIndicatorView.stopAnimating()
                    }
                }
            )
    }
    
    private func setupDataSource() {
        
        let imageSize = CGSize(width: 40, height: 40)
        let dummyImage = UIImage.createImage(with: imageSize, color: .clear)
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, User> { cell, indexPath, item in
            
            var config = UIListContentConfiguration.cell()
            
            config.text = item.id.displayName
            config.imageProperties.maximumSize = imageSize
            config.imageProperties.reservedLayoutSize = imageSize
            config.image = dummyImage
            cell.contentConfiguration = config
            
            Task {
                guard let urlStr = item.picture.thumbnail, let url = URL(string: urlStr) else { return }
                guard let image = try? await KingfisherManager.shared.asyncRetrieveImage(with: url)
                else { return }
                config.image = image
                cell.contentConfiguration = config
            }
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
}

extension UserList3ViewImpl: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DLog(indexPath)
        presenter.select(indexPath: indexPath)
    }
}

#Preview {
    MainActor.assumeIsolated {
        UserList3RouterImpl.assembleModules()
    }
}
