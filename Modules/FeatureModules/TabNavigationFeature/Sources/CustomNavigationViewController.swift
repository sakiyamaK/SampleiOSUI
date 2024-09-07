//
//  CustomNavigationViewController.swift
//
//
//  Created by sakiyamaK on 2024/05/07.
//

import UIKit
import DeclarativeUIKit
import Extensions

public final class CustomNavigationPageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    let viewControllers = Array(0...9).compactMap { index in
        CustomNavigationViewController().apply({ $0.tag = index })
    }
    
    let customNavigationBar = UIView()
        .backgroundColor(.blue)
        .height(200)
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard 
            let viewController = viewController as? CustomNavigationViewController,
            let index = viewControllers.firstIndex(where: { $0.tag == viewController.tag })
        else { return nil }
        DLog(index)
        let vc = viewControllers[safe: index - 1]
        vc?.scrollView.contentInset = .init(top: customNavigationBar.frame.height, left: 0, bottom: 0, right: 0)
        return vc
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let viewController = viewController as? CustomNavigationViewController,
            let index = viewControllers.firstIndex(where: { $0.tag == viewController.tag })
        else { return nil }
        DLog(index)
        let vc = viewControllers[safe: index + 1]
        vc?.scrollView.contentInset = .init(top: customNavigationBar.frame.height, left: 0, bottom: 0, right: 0)
        return vc
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControler = pageViewController.viewControllers?.first as? CustomNavigationViewController else { return }
        if viewControler.scrollView.contentOffset.y <= 0 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        guard completed else {
            return
        }
//        guard let viewControler = pageViewController.viewControllers?.first as? CustomNavigationViewController else { return }
//        if viewControler.scrollView.contentOffset.y <= 0 {
//            navigationController?.setNavigationBarHidden(false, animated: true)
//        }
    }

    lazy var pageViewController: UIPageViewController = {
        let pageViewController: UIPageViewController = .init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()
    
    override public func viewDidLoad() {
        self.addContainer(
            viewController: self.pageViewController,
            containerView: view,
            isSafeArea: false
        )
        
        self.declarative {
            customNavigationBar
                .top()
        }
        
        customNavigationBar.setNeedsLayout()
        customNavigationBar.layoutIfNeeded()
        
        let vc = self.viewControllers.first!
        vc.scrollView.contentInset = .init(top: customNavigationBar.frame.height, left: 0, bottom: 0, right: 0)
        self.pageViewController.setViewControllers(
            [self.viewControllers.first!],
            direction: .forward,
            animated: false,
            completion: nil
        )

    }
}

public final class CustomNavigationViewController: UIViewController {
    
    var tag: Int = 0
    
    enum Section: CaseIterable {
        case main
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    struct Delegate {
        var tap: (() -> Void)
    }
    
    var delegate: Delegate?
    var scrollView: UIScrollView { collectionView }
    private lazy var collectionView: UICollectionView = {
        UICollectionView {
            UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
        }
        .refreshControl { UIRefreshControl() }
        .apply {[weak self] in
            guard let self else { return }
            
            let listRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Int>() { cell, indexPath, index in
                // デフォルトで用意されたオプションを設定できる
                var config = UIListContentConfiguration.cell()
    //            let image = UIImage(systemName: "square.and.arrow.up")!
    //            config.image = image
    //            config.imageProperties.maximumSize = image.size
    //            config.imageProperties.reservedLayoutSize = image.size
                config.text = index.description
                config.textProperties.color = .white
                config.textProperties.font = .boldSystemFont(ofSize: 16)
                config.textProperties.numberOfLines = 2
                config.textProperties.adjustsFontSizeToFitWidth = true
                config.textProperties.alignment = .center

                // セルの設定をする
                cell.contentConfiguration = config
                cell.backgroundColor = .systemRed.withAlphaComponent(0.5)
            }

            // データソースを定義
            dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: $0) { (collectionView: UICollectionView, indexPath: IndexPath, index: Int) -> UICollectionViewCell? in
                collectionView.dequeueConfiguredReusableCell(using: listRegistration, for: indexPath, item: indexPath.item)
            }
        }
        .delegate(self)
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        self.apply({
            $0.title = "タイトルだぜ"
            $0.navigationController?.hidesBarsOnSwipe = true
            $0.view.backgroundColor(.white)
        }).declarative(safeAreas: .init(top: false, bottom: true), outsideSafeAreaTop: {
            UIView.spacer().backgroundColor(.green)
        }, outsideSafeAreaLeading: { }, outsideSafeAreaBottom: { }, outsideSafeAreaTrailing: { }) {
            collectionView
        }
                        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0...20))
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public func set(contentInset: UIEdgeInsets) {
        collectionView.contentInset = contentInset
    }
}

extension CustomNavigationViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.tap()
    }
}

#Preview {
    CustomNavigationViewController()
}
