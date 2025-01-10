//
//  CellRegistrationViewController.swift
//
//
//  Created by sakiyamaK on 2023/03/10.
//

import DeclarativeUIKit
import UIKit
import Extensions

struct ContentModel: Equatable {    
    let id: UUID = .init()
    // データ
    let name: String
    let imageName: String
    let value: Int
    var description: String {
        Array(repeating: value.description, count: 100).joined()
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// CellConfiguration用のextension
extension ContentModel: UIContentConfiguration {
    
    func makeContentView() -> UIView & UIContentView {
        ContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}

// Configurationに対応したView
final class ContentView: UIView & UIContentView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration
    
    init(configuration: ContentModel) {
        self.configuration = configuration
        
        super.init(frame: .zero)
        
        self.declarative(priorities: .init(bottom: .defaultLow)) {
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
                        
                        UILabel("\(configuration.description) ですよねええ")
                            .font(UIFont.defaultFontBold(size: 20))
                            .contentPriorities(.init(vertical: .required))
                            .numberOfLines(0)
                        UIView.spacer()
                    }
                }
                .alignment(.top)
                .padding(insets: .init(all: 20))
                UIView.divider()
            }
        }
    }
}

public final class CellRegistration02ViewController: UIViewController, UICollectionViewDelegate {
    
    deinit { }
    
    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }
    
    //サンプル
    var samples: [ContentModel] = [
        .init(name: "山田", imageName: "square.and.arrow.up", value: 1),
        .init(name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
        .init(name: "佐藤", imageName: "pencil.circle", value: 333333),
    ]
    
    
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, UUID>!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        snapshot.appendSections([0])
        snapshot.appendItems(samples.compactMap({$0.id}))
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func setupLayout() {
        
        self.applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UIStackView.vertical {
                
                UIStackView.vertical {
                    UILabel("stackviewの中でも使える")
                        .font(UIFont.defaultFontBold(size: 20))
                        .backgroundColor(.white)
                    
                    // MEMO:
                    // これまでみたいにカスタムセルでレイアウト組んだら
                    // UICollectionView以外では使いづらいみたいなことがない
                    ContentView(configuration: self.samples.first!)
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
                        
                        let registration = UICollectionView.CellRegistration<UICollectionViewCell, ContentModel> { cell, indexPath, item in
                            cell.contentConfiguration = item
                        }
                        
                        // データソースを定義
                        self.dataSource = UICollectionViewDiffableDataSource<Int, UUID>(collectionView: $0) {[weak self] (collectionView: UICollectionView, indexPath: IndexPath, item: UUID) -> UICollectionViewCell? in
                            
                            // MEMO:
                            // これまでみたいにdelegate, datasourceを用意する必要がない
                            // 更新の度にreloadData等を呼ぶ必要がない
                            
                            collectionView.dequeueConfiguredReusableCell(
                                using: registration,
                                for: indexPath,
                                item: self?.samples.first(where: { $0.id == item })!
                            )
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    CellRegistration02ViewController()
}
