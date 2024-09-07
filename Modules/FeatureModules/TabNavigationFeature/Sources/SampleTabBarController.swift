//
//  SampleTabController.swift
//  
//
//  Created by sakiyamaK on 2023/07/22.
//

import UIKit
import DeclarativeUIKit
import Extensions

public class SampleTabBarController: UITabBarController {

    private weak var previousViewController: UIViewController?

    override public func viewDidLoad() {
        super.viewDidLoad()
        
//        _ = {
//            let appearanceDefault = UINavigationBarAppearance.default
//            let appearanceClear = UINavigationBarAppearance.clear
//
//            let appearance = UINavigationBar.appearance()
//            appearance.standardAppearance = appearanceClear
//            appearance.compactAppearance = appearanceClear
//            appearance.scrollEdgeAppearance = appearanceDefault
//        }()
//        
//        _ = {
//            let appearanceDefault = UITabBarAppearance.default
//            let appearanceClear = UITabBarAppearance.clear
//            UITabBar.appearance()
//                .standardAppearance(appearanceClear)
//                .scrollEdgeAppearance(appearanceDefault)
//        }()
        
        viewControllers = [
            SampleTabBarCollectionViewController()
                .apply({
                    $0.delegate = .init(tap: {[weak self] in
                        guard let self else { return }
//                        self.navigationController?.popViewController(animated: true)
                    })
                })
                .withNavigationController
                .tabBarItem(UITabBarItem(title: "tab1", image: .none, tag: 0)),

            UIViewController().applyView({
                $0.backgroundColor(.white)
            }).declarative({
                UILabel("tab2")
                    .textColor(.systemBlue)
                    .center()
            })
            .tabBarItem(UITabBarItem(title: "tab2", image: .none, tag: 0)),
            
            UIViewController().applyView({
                $0.backgroundColor(.white)
            }).declarative({
                UILabel("tab3")
                    .textColor(.systemBlue)
                    .center()
            })
            .tabBarItem(UITabBarItem(title: "tab3", image: .none, tag: 0)),
        ]

        self.apply({
            $0.delegate = self
        }).applyView({
            $0.backgroundColor(.systemMint)
        }).applyNavigationItem {[weak self] in
            guard let self else { return }
            $0.title = self.className
        }

        
//        declarative(reset: false) {
//            UIButton("fabfab")
//                .titleColor(.systemBlue)
//                .addAction(.touchUpInside) {_ in
//                    print("tap")
//                }
//                .right()
//                .bottom()
//                .offset(.init(x: -30, y: -30))
//        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension SampleTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if previousViewController == tabBarController.selectedViewController {
            // ここに、再度選択されたときの処理を記述します
            self.navigationController?.popViewController(animated: true)
        }
        
        previousViewController = tabBarController.selectedViewController
    }
}

final class SampleTabBarCollectionViewController: UIViewController {
    enum Section: CaseIterable {
        case main
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    struct Delegate {
        var tap: (() -> Void)
    }
    
    var delegate: Delegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Int>() { cell, indexPath, index in
            DLog(index)
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


        self.declarative(safeAreas: .init(top: false, bottom: false)) {
            UICollectionView {
                UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
            }
            .apply {[weak self] in
                guard let self else { return }
                // データソースを定義
                dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: $0) { (collectionView: UICollectionView, indexPath: IndexPath, index: Int) -> UICollectionViewCell? in
                    collectionView.dequeueConfiguredReusableCell(using: listRegistration, for: indexPath, item: indexPath.item)

                }
            }
            .delegate(self)
        }
        .apply({
            $0.navigationController?.navigationBar.prefersLargeTitles = true
        }).applyNavigationItem {[weak self] in
            guard let self else { return }
            $0.largeTitleDisplayMode = .always
            $0.title = "タイトルだよ"
        }.applyView {
            $0.backgroundColor(.systemGray)
        }
                
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0...20))
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension SampleTabBarCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.tap()
    }
}

//extension UINavigationBarAppearance {
//    static var `default`: UINavigationBarAppearance {
//        let appearance = UINavigationBarAppearance()
//            .configure(.default)// 設定のリセット
//            .configure(.opaqueBackground)
//            .configure(.transparentBackground)
//            .backgroundColor(.white)
//            .shadowColor(.white)
//        
//        appearance.backButtonAppearance = {
//            let appearance = UIBarButtonItemAppearance()
//            appearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
//            appearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
//            appearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.clear]
//            return appearance
//        }()
//
//        let image = UIImage(systemName: "arrow.backward")?
//            .withTintColor(.systemGray)
//            .withRenderingMode(.alwaysOriginal)
//        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
//
//        return appearance
//    }
//    
//    static var clear: UINavigationBarAppearance {
//        let appearance = UINavigationBarAppearance()
//            .configure(.default)// 設定のリセット
//            .configure(.opaqueBackground)
//            .configure(.transparentBackground)
//            .backgroundColor(.clear)
//            .shadowColor(.clear)
//
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.clear]
//        appearance.backButtonAppearance = {
//            let appearance = UIBarButtonItemAppearance()
//            appearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
//            appearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
//            appearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.clear]
//            return appearance
//        }()
//
//        return appearance
//    }
//}
//
//extension UITabBarAppearance {
//    static var `default`: UITabBarAppearance {
//        UITabBarAppearance()
//            .configure(.default)
//            .configure(.opaqueBackground)
//            .configure(.transparentBackground)
//            .backgroundColor(.systemCyan)
//            .selectionIndicatorTintColor(.red)
//            .stackedLayoutAppearance(
//                UITabBarItemAppearance()
//                    .titleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], appearanceTypes: [.normal, .disabled, .disabled])
//                    .titleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], appearanceTypes: [.selected])
//            )
//    }
//    
//    static var clear: UITabBarAppearance {
//        UITabBarAppearance()
//            .configure(.default)
//            .configure(.opaqueBackground)
//            .configure(.transparentBackground)
//            .backgroundColor(.white.withAlphaComponent(0.3))
//            .selectionIndicatorTintColor(.darkText)
//            .stackedLayoutAppearance(
//                UITabBarItemAppearance()
//                    .titleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], appearanceTypes: [.normal, .selected, .disabled, .disabled])
//            )
//    }
//}

#Preview {
    SampleTabBarController()
}
