//
//  AppStoreDetailViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/4/7.
//

import Extensions
import DeclarativeUIKit
import UIKit

final class AppStoreDetailViewController: UIViewController {
    private var sampleModel: SampleImageModel2!

    private let appStoreFullImageView = UINib(nibName: "AppStoreFullImageView", bundle: Bundle.module).instantiate(withOwner: nil).first as! AppStoreFullImageView
    @IBOutlet var appStoreFullImageContainerView: UIView! {
        didSet {
            appStoreFullImageContainerView.addSubview(appStoreFullImageView)
            appStoreFullImageView.apply(constraints: [
                appStoreFullImageView.topAnchor.constraint(equalTo: appStoreFullImageView.topAnchor),
                appStoreFullImageView.leftAnchor.constraint(equalTo: appStoreFullImageView.leftAnchor),
                appStoreFullImageView.rightAnchor.constraint(equalTo: appStoreFullImageView.rightAnchor),
                appStoreFullImageView.bottomAnchor.constraint(equalTo: appStoreFullImageView.bottomAnchor).priority(.defaultLow),
            ])
            appStoreFullImageView.delegate = self
        }
    }

    static func makeFromStoryboard(sampleModel: SampleImageModel2, heroId: String?) -> AppStoreDetailViewController {
        let vc = UIStoryboard(name: "AppStoreDetail", bundle: Bundle.module).instantiateInitialViewController() as! AppStoreDetailViewController
        vc.sampleModel = sampleModel
        vc.appStoreFullImageView.configure(sample: sampleModel, heroId: heroId, isFullScreenMode: true)
        vc.appStoreFullImageView.hero.modifiers = [.translate(y: 200)]
        vc.hero.isEnabled = true
        return vc
    }
}

extension AppStoreDetailViewController: AppStoreFullImageViewDelegate {
    func toucheStart() {}

    func toucheEnd(sampleModel _: SampleImageModel2, heroId _: String?) {}

    func tapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}
