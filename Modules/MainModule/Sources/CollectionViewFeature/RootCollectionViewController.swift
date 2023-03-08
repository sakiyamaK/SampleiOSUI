//
//  ViewController.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/06.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

import UIKit
import DeclarativeUIKit
import Hero
import Extensions

enum ViewType: String, CaseIterable {
    
    case WaterfalCompositionallLayout
    case CompositionalLayout09
    case CompositionalLayout08
    case AppStore
    case CompositionalLayout01
    case CompositionalLayout02
    case CompositionalLayout03
    case CompositionalLayout04
    case CompositionalLayout05
    case CompositionalLayout06
    case CompositionalLayout07
    case DiffableDataSources01
    case DiffableDataSources02
    case VHScrollCollection
    case Sample1Collection
    case Sample2Collection
    case Sample3Collection
    case Sample4Collection
    case Sample5Collection
    case Sample6Collection
    case Sample7Collection
    case StoppableHeaderCollection
    case StoppableHeaderPageCollection
    case WWDC2018
    
    var viewController: UIViewController {
        switch self {
        case .WWDC2018:
            return UIStoryboard(name: "MosaicCollection", bundle: Bundle.module).instantiateInitialViewController() as! MosaicCollectionViewController
        case .CompositionalLayout01:
            return CompositionalLayout01ViewController()
        case .CompositionalLayout02:
            return CompositionalLayout02ViewController()
        case .CompositionalLayout03:
            return CompositionalLayout03ViewController()
        case .CompositionalLayout04:
            return CompositionalLayout04ViewController()
        case .CompositionalLayout05:
            return CompositionalLayout05ViewController()
        case .CompositionalLayout06:
            return CompositionalLayout06ViewController()
        case .CompositionalLayout07:
            return CompositionalLayout07ViewController()
        case .CompositionalLayout08:
            return CompositionalLayout08ViewController()
        case .CompositionalLayout09:
            return CompositionalLayout09ViewController()
        case .DiffableDataSources01:
            return DiffableDataSources01ViewController()
        case .DiffableDataSources02:
            return DiffableDataSources02ViewController()
        case .AppStore:
            return UIStoryboard(name: "AppStoreTop", bundle: Bundle.module).instantiateInitialViewController() as! AppStoreTopViewController
        case .WaterfalCompositionallLayout:
            return WaterfalCompositionallLayoutCollectionViewController()
        default:
            let sb = UIStoryboard(name: self.rawValue, bundle: Bundle.module)
            return sb.instantiateInitialViewController()!
        }
    }
    
    func button(from: UIViewController) -> UIButton {
        UIButton(self.rawValue)
            .contentEdgeInsets(.init(top: 10, left: 10, bottom: 10, right: 10))
            .font(UIFont.systemFont(ofSize: 20))
            .backgroundColor(.systemBlue)
            .cornerRadius(10)
            .add(target: from, for: .touchUpInside) { _ in
                from.navigationController?.pushViewController(self.viewController, animated: true)
            }
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

