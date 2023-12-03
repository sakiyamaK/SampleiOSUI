////
////  CellRegistrationViewController.swift
////
////
////  Created by sakiyamaK on 2023/03/10.
////

// カスタムセルなし番がまだ出来てない

import DeclarativeUIKit
import UIKit
import Extensions

struct Item: Hashable {
    let name: String
    let imageName: String
    let value: Int
    var isExpanded: Bool = false
    
    let id = UUID()
    
    static let all: [Item] = [
        .init(name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(name: "佐藤", imageName: "pencil.circle", value: 3333),
        .init(name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(name: "佐藤", imageName: "pencil.circle", value: 3333),
        .init(name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(name: "佐藤", imageName: "pencil.circle", value: 3333),
    ]
}

struct CustomContentConfiguration: UIContentConfiguration, Hashable {
    var hashValue: Int { item.id.hashValue }
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
    static func == (lhs: CustomContentConfiguration, rhs: CustomContentConfiguration) -> Bool {
        lhs.item.id == rhs.item.id
    }
    
    var item: Item
    var tapButton: (() -> Void)?

    func makeContentView() -> UIView & UIContentView {
        CustomContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        self
    }
}

class CustomContentView: UIView, UIContentView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private weak var imageView: UIImageView!
    private weak var showMore: UIButton!
    private weak var nameLabel: UILabel!
    private weak var descLabel: UILabel!
        
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? CustomContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }

    init(configuration: CustomContentConfiguration) {
        super.init(frame: .zero)
        self.declarative(priorities: .init(bottom: .defaultHigh)) {
            UIStackView.vertical {
                UIStackView.horizontal {
                    UIImageView(assign: &imageView)
                        .size(width: 40, height: 40)
                        .customSpacing(10)
                    UIStackView.vertical {
                        
                        UILabel(assign: &nameLabel)
                            .font(UIFont.defaultFontBold(size: 20))
                            .contentPriorities(.init(vertical: .required))
                            .customSpacing(8)
                        
                        UILabel(assign: &descLabel)
                            .font(UIFont.defaultFontBold(size: 20))
                            .contentPriorities(.init(vertical: .required))
                            .numberOfLines(1)
                        
                        UIButton("続きを読む")
                            .assign(to: &showMore)
                            .titleColor(.black)
                            .addAction(.touchUpInside, handler: { _ in
                                self.appliedConfiguration.tapButton?()
                            })
                            .right()
                        
                        UIView.spacer()
                    }
                }
                .alignment(.top)
                .padding(insets: .init(all: 20))
                UIView.divider()
            }
        }.apply(configuration: configuration)
    }
            
    private var appliedConfiguration: CustomContentConfiguration!
    
    private func apply(configuration: CustomContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
                
        imageView.image = UIImage(systemName: configuration.item.imageName)
        nameLabel.text = configuration.item.name
        descLabel.text = Array(repeating: configuration.item.value.description, count: 100).joined()
        descLabel.numberOfLines = configuration.item.isExpanded ? 0 : 1
        showMore.isHidden = configuration.item.isExpanded
    }
}

public class CellRegistration03ViewController: UIViewController {
    
    private var items = Item.all
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
    private var collectionView: UICollectionView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Custom Configurations"
        self.applyView({
            $0.backgroundColor(.systemBackground)
        }).declarative {
            UIStackView.vertical {
                UILabel("collectionviewの中でも使える")
                    .font(UIFont.defaultFontBold(size: 20))
                    .padding(insets: .init(all: 8))
                UICollectionView {
                    UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
                }
                .assign(to: &collectionView)
            }
        }.configureDataSource()
    }
        
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { (cell, indexPath, item) in
            var content = CustomContentConfiguration(item: item)
            content.tapButton = {[weak self] in
                guard let self else { return }
                var updateItem = item
                updateItem.isExpanded.toggle()
                self.items = self.items.compactMap { i in
                    i.id == updateItem.id ? updateItem : i
                }
                var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
                snapshot.appendSections([0])
                snapshot.appendItems(self.items)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
