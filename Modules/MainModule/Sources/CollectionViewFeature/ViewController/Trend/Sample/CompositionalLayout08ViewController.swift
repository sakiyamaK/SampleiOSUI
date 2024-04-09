//
//  CompositionalLayout08ViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/4/3.
//

// ヘッダフッダ
// 追加読み込み
// ウォーターフォール
// 1~2列

import UIKit
import Extensions

final class CompositionalLayout08ViewController: UIViewController {
    private var items: [SampleImageModel] = []
    private let limit: Int = 10
    private var offset: Int = 10
    private var loading: Bool = false

    private weak var segmentControll: UISegmentedControl!
    private weak var collectionView: UICollectionView!

    override func loadView() {
        super.loadView()

        view.backgroundColor = .white

        declarative {
            UIStackView.vertical {
                UISegmentedControl(items: ["First", "Second"]).imperative {
                    let segmentControll = $0 as! UISegmentedControl
                    segmentControll.selectedSegmentIndex = 0
                    segmentControll.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
                }
                .assign(to: &segmentControll)
                .padding()

                UICollectionView {
                    layout
                }
                .assign(to: &collectionView)
                .registerCellClass(UIImageViewCell.self, forCellWithReuseIdentifier: UIImageViewCell.reuseId)
                .registerViewClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.reuseId)
                .backgroundColor(.systemGray)
                .dataSource(self)
                .delegate(self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        SampleImageModel.load(times: 100) { [unowned self] items in
            self.items = items
            self.collectionView.reloadData()
        }
    }

    @objc func changeSegment() {
        updateLayout()
    }
}

private extension CompositionalLayout08ViewController {
    var layout: UICollectionViewLayout {
        UICollectionViewCompositionalLayout.waterfall(
            footerHeight: 80,
            numberOfColumn: CGFloat(segmentControll.selectedSegmentIndex + 1),
            numberOfItemsInSection: { [weak self] section in
                self!.collectionView.numberOfItems(inSection: section)
            },
            cellHeight: { [weak self] width, idx in
                guard let self = self, idx < self.items.count else { return 0 }
                let size = self.items[idx].image?.size ?? .zero
                let aspect = CGFloat(size.height) / CGFloat(size.width)
                let height = width * aspect
                return height
            }
        )
    }

    func updateLayout() {
        collectionView.collectionViewLayout = layout
        collectionView.alpha = 0.0
        collectionView.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.alpha = 1.0
        })
    }
}

extension CompositionalLayout08ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.reachedBottom, !loading else { return }
        loading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.offset += self.limit
            self.collectionView.reloadData()
            self.loading = false
        }
    }
}

extension CompositionalLayout08ViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items[safe: 0 ..< offset].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (collectionView.dequeueReusableCell(withReuseIdentifier: UIImageViewCell.reuseId, for: indexPath) as! UIImageViewCell)
            .configure(sample: items[safe: 0 ..< offset][indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionReusableView.reuseId, for: indexPath)
            cell.declarative {
                UIActivityIndicatorView().apply {
                    $0.startAnimating()
                }
            }
            return cell
        default:
            fatalError()
        }
    }
}
