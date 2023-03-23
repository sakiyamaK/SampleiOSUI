//
//  CellRegistrationViewController.swift
//
//
//  Created by sakiyamaK on 2023/03/10.
//

// 2023.03.23
// カスタムセルを用意せずUIView & UIContentViewとCellRegistrationの機能だけで
// 複雑なレイアウトのセルを作れるか試したが無理だった
// ここでやりたいことの一部はDiffableDataSources03ViewControllerでやっている
// DiffableDataSources03ViewControllerはUIContentViewを使えていない

import DeclarativeUIKit
import UIKit
import Extensions

struct ContentModel03: Equatable {
    // DiffableDatasource用
    struct ID: Hashable {
        let value: String
        func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.value == rhs.value
        }
    }
    
    let id: ID
    // データ
    let name: String
    let imageName: String
    let value: Int
    var description: String {
        Array(repeating: value.description, count: value).joined()
    }

    var expanded: Bool = false
    
    var tapButton: ((Self) -> Void)?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// CellConfiguration用のextension
extension ContentModel03: UIContentConfiguration {
        
    func makeContentView() -> UIView & UIContentView {
        ContentView03(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}

// Configurationに対応したView
final class ContentView03: UIView & UIContentView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private weak var label: UILabel!
    private weak var showMore: UIButton!

    private var currentConfiguration: ContentModel03!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let configuration = newValue as? ContentModel03 else { return }
            apply(configuration: configuration)            
        }
    }
    
    init(configuration: ContentModel03) {
        
        super.init(frame: .zero)
        
        self.declarative {
            UIStackView.vertical {
                UIStackView.horizontal {
                    UIImageView(image: UIImage(systemName: configuration.imageName))
                        .size(width: 40, height: 40)
                        .customSpacing(10)
                    UIStackView.vertical {
                        
                        UILabel(configuration.name)
                            .font(UIFont.defaultFontBold(size: 20))
                            .contentPriorities(.init(vertical: .required))
                            .customSpacing(8)
                        
                        UILabel("\(configuration.description) ですよ")
                            .font(UIFont.defaultFontBold(size: 20))
                            .contentPriorities(.init(vertical: .required))
                            .assign(to: &label)
                            .numberOfLines(1)
                        
                        UIButton("続きを読む")
                            .assign(to: &showMore)
                            .titleColor(.black)
                            .addAction(.touchUpInside, handler: { _ in
                                DLog(configuration.value)
                                configuration.tapButton?(configuration)
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
        
        apply(configuration: configuration)
    }
    
    private func apply(configuration: ContentModel03) {
        DLog("============ apply \(configuration.value) =========")
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration

        DLog("============ update apply \(configuration.value) =========")

        label.numberOfLines = configuration.expanded ? 0 : 1
        showMore.isHidden = configuration.expanded
    }
}

public final class CellRegistration03ViewController: UIViewController, UICollectionViewDelegate {
    
    deinit { }
    
    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }
    
    //サンプル
    var samples: [ContentModel03] = {
        var samples: [ContentModel03] = [
            .init(id: .init(value: "1"), name: "山田", imageName: "square.and.arrow.up", value: 1),
            .init(id: .init(value: "2"), name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
            .init(id: .init(value: "3"), name: "佐藤", imageName: "pencil.circle", value: 333333),
        ]
        
        return samples
    }()
    
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ContentModel03.ID>!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, ContentModel03.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(samples.compactMap({$0.id}))
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func setupLayout() {
        
        view.backgroundColor = .white
        
        self.declarative {
            UIStackView.vertical {
                
                UIStackView.vertical {
                    UILabel("stackviewの中でも使える")
                        .font(UIFont.defaultFontBold(size: 20))
                        .backgroundColor(.white)
                    
                    // MEMO:
                    // これまでみたいにカスタムセルでレイアウト組んだら
                    // UICollectionView以外では使いづらいみたいなことがない
                    ContentView03(configuration: samples.first!)
                }
                .padding(insets: .init(all: 8))
                .backgroundColor(.lightGray)
                .customSpacing(20)
                
                UIStackView.vertical {
                    UILabel("collectionviewの中でも使える")
                        .font(UIFont.defaultFontBold(size: 20))
                        .padding(insets: .init(all: 8))
                    UICollectionView {
                        UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
                    }
                    .apply({[weak self] in
                        guard let self else { return }
                        
                        let registration = UICollectionView.CellRegistration<UICollectionViewCell, ContentModel03> {[weak self] cell, indexPath, item in
                            
                            DLog("============ registration \(indexPath) =========")
                            DLog(item.value)
                            DLog(self?.samples.compactMap({ $0.value }))

                            // MEMO:
                            // これまでみたいにカスタムセルをいちいちregisterする必要はない
                            guard let self else { return }
                            
                            var item = item
                            
                            item.tapButton = { (_) in
                                item.expanded.toggle()
                                self.samples = self.samples.compactMap({
                                    $0 != item ? $0 : item
                                })
                                DLog("============ tap \(indexPath)=========")
                                DLog(item.value)
                                DLog(self.samples.compactMap({ $0.value }))

                                var snapshot = self.dataSource.snapshot()
                                snapshot.reloadItems([item.id])
                                self.dataSource.apply(snapshot, animatingDifferences: true)
                                
                            }
                            
                            cell.contentConfiguration = item
                            
                            self.samples = self.samples.compactMap({
                                $0 != item ? $0 : item
                            })
                        }
                        
                        // データソースを定義
                        self.dataSource = UICollectionViewDiffableDataSource<Int, ContentModel03.ID>(collectionView: $0) {[weak self] (collectionView: UICollectionView, indexPath: IndexPath, item: ContentModel03.ID) -> UICollectionViewCell? in
                            
                            // MEMO:
                            // これまでみたいにdelegate, datasourceを用意する必要がない
                            // 更新の度にreloadData等を呼ぶ必要がない
                            
                            guard
                                let self,
                                let sample = self.samples.first(where: { $0.id == item })
                            else { return nil }
                            
                            DLog("============ diffable \(indexPath) =========")
                            DLog(item.value)
                            DLog(self.samples.compactMap({ $0.value }))
                            
                            return collectionView.dequeueConfiguredReusableCell(
                                using: registration,
                                for: indexPath,
                                item: sample
                            )
                            
                        }
                    })
                }
            }
        }
    }
}
