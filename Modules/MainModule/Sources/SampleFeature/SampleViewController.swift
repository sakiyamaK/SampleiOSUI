//
//  SampleViewController.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2022/03/30.
//

import UIKit
import DeclarativeUIKit
import Extensions

struct SampleModel: Codable, Hashable {
    var id: Int
    var title: String? = nil
    var text: String { title ?? "" }
    var iconUrlStr: String? = nil
    var description: String? = nil
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension SampleModel {
    static func getDemoData(count: Int) -> [SampleModel] {
        [[SampleModel]](repeating: SampleModel._demoData, count: count).reduce([]) { result, value -> [SampleModel] in
            result + value
        }
    }

    static var demoData: [SampleModel] {
        getDemoData(count: 7)
    }

    private static var _demoData: [SampleModel] {
        let json = """
        [
        {
          "id": 0,
          "title": "タイトル1",
          "iconUrlStr": "https://picsum.photos/200",
          "description": "詳細情報です"
        },
        {
          "id": 1,
          "title": "タイトル2",
          "iconUrlStr": "https://picsum.photos/200/300",
          "description": "詳細情報です\\n詳細情報です\\n詳細情報です\\n詳細情報です\\n詳細情報です"
        },
        {
          "id": 2,
          "title": "タイトル3",
          "iconUrlStr": "https://via.placeholder.com/150/888888/FFFFFF"
        },
        {
          "id": 3,
          "title": "タイトル4",
          "iconUrlStr": "https://via.placeholder.com/150/888888/AAAAAA"
        },
        {
          "id": 4,
          "title": "タイトル5",
          "iconUrlStr": "https://picsum.photos/300"
        },
        {
          "id": 5,
          "title": "タイトル6",
          "iconUrlStr": "https://via.placeholder.com/150/888888/FFAABB"
        },
        {
          "id": 6,
          "title": "タイトル7",
          "iconUrlStr": "https://picsum.photos/400"
        }

        ]
        """.data(using: .utf8)!
        return (try? JSONDecoder().decode([SampleModel].self, from: json)) ?? []
    }
}

struct SampleModelConfiguration: UIContentConfiguration, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(model.id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.model == rhs.model
    }
    
    var model: SampleModel
    
    var viewClosure: ((Self) -> UIView & UIContentView)?

    func makeContentView() -> UIView & UIContentView {
        viewClosure!(self)
//        return SampleView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}

class SampleView01: UIView, UIContentView {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var configuration: UIContentConfiguration

    init(configuration: SampleModelConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        declarative {
            UIStackView.vertical {
                UILabel(configuration.model.title)
                    .font(UIFont.defaultFontBold(size: 20))
                    .contentPriorities(.init(vertical: .required))
                    .padding(insets: .init(all: 20))
                UIView.divider()
            }
        }
    }
}

class SampleView02: UIView, UIContentView {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var configuration: UIContentConfiguration

    init(configuration: SampleModelConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        declarative {
            UIStackView.vertical {
                UIStackView.vertical {
                    UILabel(configuration.model.title)
                        .font(UIFont.defaultFontBold(size: 20))
                        .contentPriorities(.init(vertical: .required))
                    UILabel(configuration.model.iconUrlStr)
                        .font(UIFont.defaultFontBold(size: 10))
                        .numberOfLines(0)
                        .contentPriorities(.init(vertical: .required))
                }
                .padding(insets: .init(all: 20))
                UIView.divider()
            }
        }
    }
}


public final class SampleViewController: UIViewController, UICollectionViewDelegate {

    deinit {
    }

    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let samples = SampleModel.demoData
        // 新しいsnapshotを用意する
        var snapshot = NSDiffableDataSourceSnapshot<Int, SampleModel>()
        // セクションの数を登録する
        snapshot.appendSections([0])
        // セルの配列を登録する
        snapshot.appendItems(samples)
        // データソースにsnapshotを適応させる
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    var dataSource: UICollectionViewDiffableDataSource<Int, SampleModel>!

    @objc private func setupLayout() {

        view.backgroundColor = .white
                        
        self.declarative {
            UIStackView.vertical {
//                SampleView01(configuration: SampleModelConfiguration(model: SampleModel.demoData.first!))
//                SampleView02(configuration: SampleModelConfiguration(model: SampleModel.demoData.first!))
//                UIListContentView().apply {
//                    var config = UIListContentConfiguration.cell()
//                    config.text = "hoge"
//                    $0.configuration = config
//                }
                UICollectionView {
                    UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
                }
                .apply({[weak self] in
                    guard let self else { return }
                    
                    let registration = UICollectionView.CellRegistration<UICollectionViewCell, SampleModel> { cell, indexPath, model in
                        var conf = SampleModelConfiguration(model: model)
                        if indexPath.item%2 == 0 {
                            conf.viewClosure = { conf in
                                SampleView01(configuration: conf)
                            }
                        } else {
                            conf.viewClosure = { conf in
                                SampleView02(configuration: conf)
                            }
                        }
                        cell.contentConfiguration = conf
                    }

                    // データソースを定義
                    self.dataSource = UICollectionViewDiffableDataSource<Int, SampleModel>(collectionView: $0) { (collectionView: UICollectionView, indexPath: IndexPath, item: SampleModel) -> UICollectionViewCell? in
                        collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
                    }
                })
            }
            .distribution(.fill)
        }
    }
}
