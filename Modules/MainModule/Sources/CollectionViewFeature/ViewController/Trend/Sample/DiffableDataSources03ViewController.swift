//
//  DiffableDataSources03ViewController.swift
//  
//
//  Created by sakiyamaK on 2023/03/12.
//

import UIKit
import DeclarativeUIKit
import Extensions


struct DiffableDatasourceID: Hashable {
    var identifier: UUID = .init()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

protocol CellProtocol: Equatable {
    var id: DiffableDatasourceID { get }
    static func == (lhs: Self, rhs: Self) -> Bool
}

extension CellProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

struct CellModel01: CellProtocol {
    var id: DiffableDatasourceID = .init()
    var text: String
}

struct CellModel02: CellProtocol {
    var id: DiffableDatasourceID = .init()
    var value: Int
}

struct SectionModel: Hashable {
    var section: Int = 0
    var tapCount: Int = 0

    func hash(into hasher: inout Hasher) {
        hasher.combine(section)
    }
}

final class CollecitonHeader: UICollectionReusableView {

    private weak var label: UILabel!
    private var section: Int!
    private var tapCount: Int!

    var tapCell: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        section = 0
        tapCount = 0
        label.text = nil
        tapCell = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func setupLayout() {
        self.backgroundColor = .white

        self.declarative {
            UILabel(assign: &label)
                .contentPriorities(.init(vertical: .required))
                .isUserInteractionEnabled(true)
                .padding(insets: .init(top: 20, left: 8, bottom: 20, right: 8))
                .addGestureRecognizer {
                    UITapGestureRecognizer(target: self) {[weak self] _ in
                        guard let self else { return }
                        self.tapCell?(self.section)
                    }
                }
        }
    }

    func configure(section: Int, tapCount: Int) {
        self.section = section
        self.tapCount = tapCount
        self.label.text = section.description + " = " + tapCount.description
    }
}

final class AccordionCollectionViewCell: UICollectionViewCell {
    private weak var label: UILabel!
    private var indexPath: IndexPath!

    var tapCell: ((IndexPath) -> Void)?

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        indexPath = .init(row: 0, section: 0)
        tapCell = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func setupLayout() {

        self.contentView.declarative {
            UILabel(assign: &label)
                .font(UIFont.defaultFontBold(size: 20))
                .contentPriorities(.init(vertical: .required))
                .isUserInteractionEnabled(true)
                .padding(insets: .init(top: 20, left: 8, bottom: 20, right: 8))
                .addGestureRecognizer {
                    UITapGestureRecognizer(target: self) {[weak self] _ in
                        guard let self else { return }
                        self.tapCell?(self.indexPath)
                    }
                }
        }
    }

    func configure(sample: CellModel01, indexPath: IndexPath) {
        self.indexPath = indexPath
        label.text = sample.text
    }
}

final class AccordionCollectionViewCell2: UICollectionViewCell {
    private weak var label: UILabel!
    private var indexPath: IndexPath!

    var tapCell: ((IndexPath) -> Void)?

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        indexPath = .init(row: 0, section: 0)
        tapCell = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func setupLayout() {

        self.contentView.declarative {
            UILabel(assign: &label)
                .font(UIFont.defaultFontBold(size: 20))
                .contentPriorities(.init(vertical: .required))
                .isUserInteractionEnabled(true)
                .padding(insets: .init(top: 20, left: 8, bottom: 20, right: 8))
                .backgroundColor(.green)
                .addGestureRecognizer {
                    UITapGestureRecognizer(target: self) {[weak self] _ in
                        guard let self else { return }
                        self.tapCell?(self.indexPath)
                    }
                }
        }
    }

    func configure(sample: CellModel02, indexPath: IndexPath) {
        self.indexPath = indexPath
        label.text = sample.value.description
    }
}

public final class DiffableDataSources03ViewController: UIViewController, UICollectionViewDelegate {

    deinit { }

    private var snapshot: NSDiffableDataSourceSnapshot<SectionModel, DiffableDatasourceID> = .init()
    private var dataSource: UICollectionViewDiffableDataSource<SectionModel, DiffableDatasourceID>?

    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }

    private weak var collectionView: UICollectionView!

    private var sampless: [[SectionModel: [any CellProtocol]]] = .init()
    func createSampless(emptySection: Int? = nil, newSection: SectionModel? = nil) -> [[SectionModel: [any CellProtocol]]] {
        (0...10).compactMap { sectionIndex -> [SectionModel: [any CellProtocol]] in
            var sectionModel = newSection ?? SectionModel(section: sectionIndex)
            sectionModel.section = sectionIndex
            return switch sectionIndex {
            case emptySection:
                [sectionModel: []]
            default:
                if sectionIndex%2 == 0 {
                    [sectionModel: (0...5).compactMap { cellIndex in
                        CellModel01(text: "\(sectionIndex)_\(cellIndex)")
                    }]
                } else {
                    [sectionModel: (0...5).compactMap { cellIndex in
                        CellModel02(value: cellIndex)
                    }]
                }
            }
        }
    }
    
    func getSample(id: DiffableDatasourceID) -> (any CellProtocol)? {
        sampless.compactMap({ $0.values as? any CellProtocol })
            .compactMap({ $0 }).first(where: { $0.id == id })
    }
    
    var ids: [DiffableDatasourceID] {
        sampless.compactMap({ $0.values as? any CellProtocol }).compactMap({ $0.id })
    }

    @objc private func setupLayout() {

        applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout { _, layoutEnvironment in

                    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                    configuration.headerMode = .supplementary

                    return NSCollectionLayoutSection.list(
                        using: configuration,
                        layoutEnvironment: layoutEnvironment
                    )
                }
            }
            .refreshControl({
                UIRefreshControl()
                    .add(target: self, for: .valueChanged) {[weak self] _ in
                        guard let self = self else { return }
                        self.sampless = self.createSampless()
                        self.performQuery(sampless: self.sampless)
                    }
            })
            .assign(to: &collectionView)
//            .registerCellClass(AccordionCollectionViewCell.self, forCellWithReuseIdentifier: AccordionCollectionViewCell.className)
//            .registerCellClass(AccordionCollectionViewCell2.self, forCellWithReuseIdentifier: AccordionCollectionViewCell2.className)
//            .registerViewClass(CollecitonHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollecitonHeader.className)
        }

        snapshot = .init()
        configureDataSource()
        self.sampless = self.createSampless()
        self.performQuery(sampless: self.sampless)
    }
}

private extension DiffableDataSources03ViewController {
    
    func configureDataSource() {
        let accordionCollectionViewCellRegistration = UICollectionView.CellRegistration<AccordionCollectionViewCell, DiffableDatasourceID> { cell, indexPath, id in
            guard let sample = self.getSample(id: id) as? CellModel01 else {
                return
            }
            cell.configure(sample: sample, indexPath: indexPath)
        }
        let accordionCollectionViewCell2Registration = UICollectionView.CellRegistration<AccordionCollectionViewCell2, DiffableDatasourceID> { cell, indexPath, id in
            guard let sample = self.getSample(id: id) as? CellModel02 else {
                return
            }
            cell.configure(sample: sample, indexPath: indexPath)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<CollecitonHeader>(elementKind: UICollectionView.elementKindSectionHeader) {[weak self] view, _, indexPath in
            guard let self, let section = self.sampless[indexPath.section].keys.first else { return }
            view.configure(section: indexPath.section, tapCount: section.tapCount)
            view.tapCell = {[weak self] (selectSection) in
                guard let self, let section = self.sampless[selectSection].keys.first else { return }

                var newSection = section
                newSection.tapCount += 1
                view.configure(section: indexPath.section, tapCount: newSection.tapCount)

                let emptySection = self.snapshot.itemIdentifiers(inSection: section).isEmpty ? nil : selectSection
                self.sampless = self.createSampless(emptySection: emptySection, newSection: newSection)
                self.performQuery(sampless: self.sampless)
            }
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, cellHasable in
            if indexPath.section%2 == 0 {
                collectionView.dequeueConfiguredReusableCell(using: accordionCollectionViewCellRegistration, for: indexPath, item: cellHasable)
            } else {
                collectionView.dequeueConfiguredReusableCell(using: accordionCollectionViewCell2Registration, for: indexPath, item: cellHasable)
            }
        })

        dataSource?.supplementaryViewProvider = { (collectionView, _, indexPath) in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }

    func performQuery(sampless: [[SectionModel: [any CellProtocol]]]) {
        snapshot.deleteAllItems()
        let sections = Array(sampless.compactMap({ $0.keys.first }))
        snapshot.appendSections(sections)
        for samples in sampless {
            guard let key = samples.keys.first, let arr = samples[key] else { continue }
            snapshot.appendItems(arr.compactMap({ $0.id }), toSection: key)
        }
        dataSource?.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.collectionView?.refreshControl?.endRefreshing()
        }
    }
}
