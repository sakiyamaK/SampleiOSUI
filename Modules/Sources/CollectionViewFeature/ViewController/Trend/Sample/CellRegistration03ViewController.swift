////
////  CellRegistrationViewController.swift
////
////
////  Created by sakiyamaK on 2023/03/10.
////

import DeclarativeUIKit
import UIKit
import Extensions

struct Item: Hashable {
    
    let uuid = UUID()
    
    let id: Int
    let name: String
    let imageName: String
    let value: Int
    var isExpanded: Bool = false
    
    static let all: [Item] = {
        [
            .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
            .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
            .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
            .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
            .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
            .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
            .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
            .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
            .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
            .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
            .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
            .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
            .init(id: 1, name: "山田", imageName: "square.and.arrow.up", value: 1),
            .init(id: 2, name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
            .init(id: 3, name: "佐藤", imageName: "pencil.circle", value: 3333),
        ]
    }()
}

struct CustomContentConfiguration: UIContentConfiguration, Equatable {

    static func == (lhs: CustomContentConfiguration, rhs: CustomContentConfiguration) -> Bool {
        lhs.item.uuid == rhs.item.uuid
    }

    let item: Item
    let delegate: CustomContentView.Delegate?

    func makeContentView() -> UIView & UIContentView {
        CustomContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        self
    }
}

class CustomContentView: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private weak var imageView: UIImageView!
    private weak var showMore: UIButton!
    private weak var nameLabel: UILabel!
    private weak var descLabel: UILabel!
    
    struct Delegate {
        var tapButton: ((CustomContentView) -> Void)?
    }
    private var delegate: Delegate?
    
    private func setupLayout() {
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
                            .addAction(.touchUpInside, handler: {[weak self] _ in
                                guard let self else { return }
                                self.delegate?.tapButton?(self)
                            })
                            .right()
                        
                        UIView.spacer()
                    }
                }
                .alignment(.top)
                .padding(insets: .init(all: 20))
                UIView.divider()
            }
        }
    }
    
    // 普通のUIViewとして使う時に必要な実装
    init(item: Item, delegate: Delegate? = nil) {
        super.init(frame: .zero)
        setupLayout()
        apply(item: item)
        self.delegate = delegate
    }
    
    func apply(item: Item) {
        imageView.image = UIImage(systemName: item.imageName)
        nameLabel.text = item.name
        descLabel.text = Array(repeating: item.value.description, count: 100).joined()
        descLabel.numberOfLines = item.isExpanded ? 0 : 1
        showMore.title(item.isExpanded ? "閉じる" : "続きを読む")
    }
     
    /***
     UIContentViewに必要なパラメータ
     */
    private var appliedConfiguration: CustomContentConfiguration!
}

extension CustomContentView: UIContentView {
    // UIContentViewのprotocolとして実装がいる
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? CustomContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    convenience init(configuration: CustomContentConfiguration) {
        self.init(item: configuration.item, delegate: configuration.delegate)
        appliedConfiguration = configuration
    }
            
    private func apply(configuration: CustomContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        apply(item: configuration.item)
        delegate = appliedConfiguration.delegate
    }
}

public class CellRegistration03ViewController: UIViewController {
    
    deinit { DLog() }
    
    private var itemsInStackView = Item.all.first!
    private var items = Item.all

    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.applyView({
            $0.backgroundColor(.systemBackground)
        }).applyNavigationItem({
            $0.title = "Custom Configurations"
        }).declarative {
            UIStackView.vertical {
                UILabel("stackviewの中でも使える")
                    .font(UIFont.defaultFontBold(size: 20))
                    .padding(insets: .init(all: 8))
                
                CustomContentView(
                    item: itemsInStackView,
                    delegate: .init(
                        tapButton: {[weak self] view in
                            guard let self else { return }
                            self.itemsInStackView.isExpanded.toggle()
                            view.apply(item: self.itemsInStackView)
                        }
                    )
                )
                UILabel("collectionviewの中でも使える")
                    .font(UIFont.defaultFontBold(size: 20))
                    .padding(insets: .init(all: 8))
                
                UICollectionView {
                    UICollectionViewCompositionalLayout.list(
                        using: .init(
                            appearance: .insetGrouped
                        )
                    )
                }
                .apply({ collectionView in
                    // dequeueConfiguredReusableCellでその都度生成はできないのでちゃんと定数化しておく
                    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { [weak self] (cell, indexPath, item) in
                        cell.contentConfiguration = CustomContentConfiguration(
                            item: item,
                            delegate: .init(
                                tapButton: {[weak self] _ in
                                    guard let self else { return }
                                    var updateItem = item
                                    updateItem.isExpanded.toggle()
                                    self.items = self.items.compactMap { item in
                                        item.uuid == updateItem.uuid ? updateItem : item
                                    }
                                    self.applySnapshot(items: self.items, animatingDifferences: true)
                                }
                            )
                        )
                    }
                    
                    dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView) {
                        (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
                        collectionView.dequeueConfiguredReusableCell(
                            using: cellRegistration,
                            for: indexPath,
                            item: item
                        )
                    }
                })
            }
        }
        
        // initial data
        self.applySnapshot(items: items, animatingDifferences: false)
    }

    private func applySnapshot(items: [Item], animatingDifferences: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

#Preview {
    CellRegistration03ViewController()
}
