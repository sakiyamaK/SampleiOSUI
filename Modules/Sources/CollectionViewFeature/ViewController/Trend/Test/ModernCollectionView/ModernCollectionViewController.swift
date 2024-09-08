//
//  MordernCollectionViewController.swift
//
//
//  Created by sakiyamaK on 2024/06/15.
//

import UIKit
import ModernCollectionView

class ModernContentView1: UIView, UIContentView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Configuration: UIContentConfiguration, Equatable {
        
        let item: Int
        
        func makeContentView() -> UIView & UIContentView {
            ModernContentView1(configuration: self)
        }
        
        public func updated(for state: UIConfigurationState) -> Self {
            self
        }
    }
    
    var configuration: UIContentConfiguration {
        didSet { configure() }
    }
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        // view layout
    }
    
    private var fixedConfiguration: Configuration {
        configuration as! Configuration
    }
    
    private func configure() {
        // update view
    }
}

typealias ModernContentView2 = ModernContentView1


enum ModernCollectionViewSection: Int {
    case section1 = 0, section2
}

public class NormalCollectionViewController: UIViewController {
    
    private var datasourceWithSection = [
        ModernCollectionViewSection.section1: Array(0..<10),
        ModernCollectionViewSection.section2: Array(20..<30)
    ]
    
    private var diffableDatasource: UICollectionViewDiffableDataSource<ModernCollectionViewSection, Int>!

    private var cell1: UICollectionView.CellRegistration<UICollectionViewCell, Int> = .init(handler: { cell, indexPath, item in
        cell.contentConfiguration = ModernContentView1.Configuration(item: item)
    })
    private var cell2: UICollectionView.CellRegistration<UICollectionViewCell, Int> = .init(handler: { cell, indexPath, item in
        cell.contentConfiguration = ModernContentView2.Configuration(item: item)
    })
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout.list(using: .init(appearance: .grouped)))
        
        // autolayout
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        diffableDatasource = .init(collectionView: collectionView, cellProvider: { [weak self]  collectionView, indexPath, itemIdentifier in
            guard let self else { fatalError() }
            let section = ModernCollectionViewSection(rawValue: indexPath.section)!
            let item = self.datasourceWithSection[section]![indexPath.item]
            return switch section {
            case .section1:
                collectionView.dequeueConfiguredReusableCell(using: cell1, for: indexPath, item: item)
            case .section2:
                collectionView.dequeueConfiguredReusableCell(using: cell2, for: indexPath, item: item)
            }
        })

        var snapshot = NSDiffableDataSourceSnapshot<ModernCollectionViewSection, Int>()
        snapshot.appendSections(datasourceWithSection.map({ $0.key }))
        for (section, items) in datasourceWithSection {
            snapshot.appendItems(items, toSection: section)
        }
        diffableDatasource.apply(snapshot, animatingDifferences: true)
    }
}


//        // セクションがひとつ
//        ModernCollectionView(collectionViewLayoutBuilder: {
//            UICollectionViewCompositionalLayout.list(using: .init(appearance: .grouped))
//        }, cellRegistrationHandler: { (cell, indexPath, item) -> Void in
//            cell.contentConfiguration = ModernContentView1.Configuration(item: item)
//        }).apply(datasource: datasource, animatingDifferences: false)
//
//        // セクションがひとつ
//        ModernCollectionView(collectionViewLayoutBuilder: {
//            UICollectionViewCompositionalLayout.list(using: .init(appearance: .grouped))
//        }, { (cell, indexPath, item) -> Void in
//            cell.contentConfiguration = ModernContentView1.Configuration(item: item)
//        }).apply(datasource: datasource, animatingDifferences: false)
//
//        // セクションが複数でセクションはIntで管理
//        ModernCollectionView(collectionViewLayoutBuilder: {
//            UICollectionViewCompositionalLayout.list(using: .init(appearance: .grouped))
//        }, cellRegistrationHandlers: [
//            { (cell, indexPath, item) -> Void in
//                cell.contentConfiguration = ModernContentView1.Configuration(item: item)
//            },
//            { (cell, indexPath, item) -> Void in
//                cell.contentConfiguration = ModernContentView2.Configuration(item: item)
//            },
//        ]).apply(datasource: datasource, animatingDifferences: false)
//
//        // セクションが複数でセクションはHashable&Sendableなenumで管理
//        ModernCollectionView(collectionViewLayoutBuilder: {
//            UICollectionViewCompositionalLayout.list(using: .init(appearance: .grouped))
//        }, cellRegistrationHandlers: [
//            .section1: { (cell, indexPath, item) -> Void in
//                cell.contentConfiguration = ModernContentView1.Configuration(item: item)
//            },
//            .section2: { (cell, indexPath, item) -> Void in
//                cell.contentConfiguration = ModernContentView2.Configuration(item: item)
//            }
//        ]).apply(datasource: datasource2, animatingDifferences: false)
