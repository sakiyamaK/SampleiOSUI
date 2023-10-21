//
//  SampleAffineViewController.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2022/08/07.
//

import DeclarativeUIKit
import UIKit
import Extensions
import ResourceFeature

public final class SampleAffineViewController: UIViewController {
    public override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        
        setupLayout()
    }
}

@objc private extension SampleAffineViewController {
    func setupLayout() {
        do {
            try R.validate()
        } catch(let e) {
            DLog(e)
        }
        let range = (0 ... 10)
        let count = range.count
        
        applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UIStackView.vertical {

                UIStackView.horizontal {
                    range.compactMap { num in
                        
                        UIImageView(R.image.lufy())
                            .contentMode(.scaleAspectFit)
                            .backgroundColor(num == count / 2 ? .systemRed : .systemGray)
                            .width(UIScreen.main.bounds.width / CGFloat(count))
                            .aspectRatio(1.0)
                            .apply {
                                let dNum = Double(num)
                                let dCount = Double(count - 1)
                                let v: Double = (dNum * 2 / dCount) - 1
                                let angle: Double = v * 0.48 * Double.pi
                                $0.transform3D = CATransform3DRotate(CATransform3DIdentity, angle, 0, 1, 0)
                            }
                            .shadow(color: .black, radius: 10, x: 1, y: 1)
                    }
                }
                .alignment(.center)
            }
            .center()
        }
    }
}
