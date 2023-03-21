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
    var samples: [ContentModel] = {
        var samples: [ContentModel] = [
            .init(id: .init(value: "1"), name: "山田", imageName: "square.and.arrow.up", value: 1),
            .init(id: .init(value: "2"), name: "田中", imageName: "square.and.arrow.up.circle.fill", value: 222),
            .init(id: .init(value: "3"), name: "佐藤", imageName: "pencil.circle", value: 333333),
        ]
                
        return samples
    }()


    private var dataSource: UICollectionViewDiffableDataSource<Int, ContentModel.ID>!

    override public func viewDidLoad() {
        super.viewDidLoad()

        var snapshot = NSDiffableDataSourceSnapshot<Int, ContentModel.ID>()
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
                    ContentView(configuration: samples.first!)
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
                        self.dataSource = UICollectionViewDiffableDataSource<Int, ContentModel.ID>(collectionView: $0) {[weak self] (collectionView: UICollectionView, indexPath: IndexPath, item: ContentModel.ID) -> UICollectionViewCell? in
                            
                            // MEMO:
                            // これまでみたいにdelegate, datasourceを用意する必要がない
                            // 更新の度にreloadData等を呼ぶ必要がない
                            
                            guard let sample = self?.samples.first(where: { $0.id == item }) else {
                                return nil
                            }
                            
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
