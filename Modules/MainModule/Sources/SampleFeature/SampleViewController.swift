//
//  SampleViewController.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2022/03/30.
//

import UIKit
import DeclarativeUIKit
import ObservableUIKit
import Extensions
import Components
import RxCocoa
import RxSwift
import RxOptional
import SwiftyAttributes
import ResourceFeature

public class SampleViewController: UIViewController {
    
    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        
        setupLayout()
    }
    
    
    @objc func setupLayout() {
        self
            .applyView({
                $0.backgroundColor(.white)
            })
            .declarative {
                UIStackView.vertical {
                    UILabel(
                        R.string.localizable.lufy()
                    )
                    .textColor(.red)
                    .numberOfLines(0)
                    .contentPriorities(.init(vertical: .required))
                    .textAlignment(.center)
                    .customSpacing(30)
                    
                    UIImageView(R.image.lufy())
                        .contentMode(.scaleAspectFit)
                        .width(UIScreen.main.bounds.width)
                        .aspectRatio(1.0)
                }.center()
            }
    }
}

//#Preview {
//    SampleViewController()
//}
