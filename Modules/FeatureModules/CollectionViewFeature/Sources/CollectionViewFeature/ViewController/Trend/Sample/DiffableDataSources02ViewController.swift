//
//  DiffableDataSources02ViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/4/1.
//

import UIKit

final class DiffableDataSources02ViewController: UIViewController {
    final class SortSection: Hashable {
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: SortSection, rhs: SortSection) -> Bool {
            lhs.identifier == rhs.identifier
        }

        private var identifier = UUID()

        var isSorted: Bool { nodes == nodes.sorted() }

        private(set) var nodes: [SampleModel03] = []

        func create(times: Int) {
            nodes = SampleModel03.createSamples(times: times)
        }

        func sorted() -> [SampleModel03] {
            for index in 0 ..< nodes.count - 1 {
                let now = nodes[index]
                let next = nodes[index + 1]
                nodes[index] = max(now, next)
                nodes[index + 1] = min(now, next)
            }
            return nodes
        }
    }

    private let columns: Int = 20
    private let rows: Int = 20

    var dataSource: UICollectionViewDiffableDataSource<SortSection, SampleModel03>!

    private weak var collectionView: UICollectionView!

    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        declarative {
            UIStackView.vertical {
                UIButton("Sort")
                    .titleColor(.systemBlue)
                    .contentHuggingPriority(.required, for: .vertical)
                    .contentCompressionResistancePriority(.required, for: .vertical)
                    .add(target: self, for: .touchUpInside) { [weak self] _ in
                        self?.sort()
                    }
                    .right()
                    .padding(insets: .init(top: 6, left: 6, bottom: 6, right: 6))
                UICollectionView {
                    UICollectionViewCompositionalLayout.init { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .fractionalHeight(1.0))
                        let item = NSCollectionLayoutItem(layoutSize: size)

                        let contentSize = layoutEnvironment.container.effectiveContentSize
                        let rowHeight = contentSize.height / CGFloat(self.rows)
                        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                               heightDimension: .absolute(rowHeight))
                        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: self.columns)
                        let section = NSCollectionLayoutSection(group: group)
                        return section
                    }
                }
                .registerCellClass(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.reuseId)
                .assign(to: &collectionView)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        performQuery()
    }
}

private extension DiffableDataSources02ViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SortSection, SampleModel03>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, sample: SampleModel03) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reuseId, for: indexPath)
            cell.backgroundColor = sample.color
            return cell
        }
    }

    func performQuery() {
        var snapshot = NSDiffableDataSourceSnapshot<SortSection, SampleModel03>()
        for _ in 1 ... rows {
            let section = SortSection()
            section.create(times: columns)
            snapshot.appendSections([section])
            snapshot.appendItems(section.nodes)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func sort() {
        var updateSnapshot = dataSource.snapshot()
        let isSorted = updateSnapshot.sectionIdentifiers.allSatisfy { $0.isSorted }
        guard !isSorted else {
            return
        }

        updateSnapshot.sectionIdentifiers.forEach {
            let section = $0
            let items = section.nodes
            let sorted = section.sorted()
            updateSnapshot.deleteItems(items)
            updateSnapshot.appendItems(sorted, toSection: section)
        }

        dataSource.apply(updateSnapshot)

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(125)) {
            self.sort()
        }
    }
}

#Preview {
    DiffableDataSources02ViewController()
}
