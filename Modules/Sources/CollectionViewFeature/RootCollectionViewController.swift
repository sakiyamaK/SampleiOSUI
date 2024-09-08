//
//  RootCollectionViewController.swift
//
//  Created by sakiyamaK on 2020/06/06.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

import UIKit
import DeclarativeUIKit
import Hero
import Extensions

private enum ViewType: String, CaseIterable {

    // Trend
    case Sample
    case AppStore
    case WaterfalCompositionallLayout
    case CellRegistration01
    case CellRegistration02
    case CellRegistration03
    case CompositionalLayout01
    case CompositionalLayout02
    case CompositionalLayout03
    case CompositionalLayout04
    case CompositionalLayout05
    case CompositionalLayout06
    case CompositionalLayout07
    case CompositionalLayout08
    case CompositionalLayout09
    case DiffableDataSources01
    case DiffableDataSources02
    case DiffableDataSources03
    // Regacy
    case VHScrollCollection
    case Sample1Collection
    case Sample2Collection
    case Sample3Collection
    case Sample4Collection
    case Sample5Collection
    case Sample6Collection
    case Sample7Collection
//    case StoppableHeaderCollection
//    case StoppableHeaderPageCollectionView
    case WWDC2018

    var viewController: UIViewController {
        switch self {
        case .Sample:
            SampleCollectionViewController()
        case .WWDC2018:
            MosaicCollectionViewController()
        case .AppStore:
            AppStoreTopViewController()
        case .CellRegistration01:
            CellRegistration01ViewController()
        case .CellRegistration02:
            CellRegistration02ViewController()
        case .CellRegistration03:
            CellRegistration03ViewController()
        case .WaterfalCompositionallLayout:
            WaterfalCompositionallLayoutCollectionViewController()
        case .CompositionalLayout09:
            CompositionalLayout09ViewController()
        case .CompositionalLayout08:
            CompositionalLayout08ViewController()
        case .CompositionalLayout01:
            CompositionalLayout01ViewController()
        case .CompositionalLayout02:
            CompositionalLayout02ViewController()
        case .CompositionalLayout03:
            CompositionalLayout03ViewController()
        case .CompositionalLayout04:
            CompositionalLayout04ViewController()
        case .CompositionalLayout05:
            CompositionalLayout05ViewController()
        case .CompositionalLayout06:
            CompositionalLayout06ViewController()
        case .CompositionalLayout07:
            CompositionalLayout07ViewController()
        case .DiffableDataSources01:
            DiffableDataSources01ViewController()
        case .DiffableDataSources02:
            DiffableDataSources02ViewController()
        case .DiffableDataSources03:
            DiffableDataSources03ViewController()
        case .VHScrollCollection:
            VHScrollCollectionViewController.makeFromStroryboard(name: "VHScrollCollection", bundle: .module)!
        case .Sample1Collection:
            Sample1CollectionViewController.makeFromStroryboard(name: "Sample1Collection", bundle: .module)!
        case .Sample2Collection:
            Sample2CollectionViewController.makeFromStroryboard(name: "Sample2Collection", bundle: .module)!
        case .Sample3Collection:
            Sample3CollectionViewController.makeFromStroryboard(name: "Sample3Collection", bundle: .module)!
        case .Sample4Collection:
            Sample4CollectionViewController.makeFromStroryboard(name: "Sample4Collection", bundle: .module)!
        case .Sample5Collection:
            Sample5CollectionViewController.makeFromStroryboard(name: "Sample5Collection", bundle: .module)!
        case .Sample6Collection:
            Sample6CollectionViewController.makeFromStroryboard(name: "Sample6Collection", bundle: .module)!
        case .Sample7Collection:
            Sample7CollectionViewController.makeFromStroryboard(name: "Sample7Collection", bundle: .module)!
        }
    }

    func button(from: UIViewController) -> UIButton {
        UIButton(self.rawValue)
            .configuration(
                UIButton.Configuration.filled()
                    .baseBackgroundColor(.systemBlue)
                    .cornerStyle(.capsule)
            )
            .font(UIFont.systemFont(ofSize: 20))
            .addAction(.touchUpInside, handler: { _ in
                from.navigationController?.pushViewController(self.viewController, animated: true)
            })
    }
}


public final class RootCollectionViewController: UIViewController {

    public override func loadView() {
        super.loadView()

        self.view.backgroundColor = .white
        self.navigationItem.title = "Root"

        self.declarative {
            UIScrollView.vertical {
                UIStackView.vertical {
                    ViewType.allCases.compactMap({ $0.button(from: self).height(40) })
                }
                .spacing(20)
                .distribution(.fillEqually)
                .alignment(.center)
                .center()
            }
            .showsScrollIndicator(false)
        }
    }
}

#Preview {
    RootCollectionViewController()
}

