//
//  SampleViewController.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2022/03/30.
//

import UIKit
import DeclarativeUIKit
import Extensions

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


    @objc private func setupLayout() {

        view.backgroundColor = .white
        
        self.declarative {
            UIStackView.vertical {
                UIListContentView().apply {
                    var config = UIListContentConfiguration.cell()
                    config.text = "hoge"
                    $0.configuration = config
                }
                UIListContentView().apply {
                    var config = UIListContentConfiguration.cell()
                    config.text = "hoge"
                    $0.configuration = config
                }
                UIListContentView().apply {
                    var config = UIListContentConfiguration.cell()
                    config.text = "hoge"
                    $0.configuration = config
                }
                UIListContentView().apply {
                    var config = UIListContentConfiguration.cell()
                    config.text = "hoge"
                    $0.configuration = config
                }
                UIListContentView().apply {
                    var config = UIListContentConfiguration.cell()
                    config.text = "hoge"
                    $0.configuration = config
                }
            }
            .distribution(.fillEqually)
        }
    }
}

