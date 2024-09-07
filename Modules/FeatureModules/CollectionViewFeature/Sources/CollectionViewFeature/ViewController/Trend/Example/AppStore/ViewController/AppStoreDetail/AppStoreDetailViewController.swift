//
//  AppStoreDetailViewController.swift
//  SampleCompositonalLayout
//
//  Created by  on 2021/4/7.
//

import SnapKit
import UIKit

final class AppStoreDetailViewController: UIViewController {
    private var sampleModel: SampleImageModel2!

    private let appStoreFullImageView = UINib(nibName: "AppStoreFullImageView", bundle: Bundle.module).instantiate(withOwner: nil).first as! AppStoreFullImageView
    @IBOutlet var appStoreFullImageContainerView: UIView! {
        didSet {
            appStoreFullImageContainerView.addSubview(appStoreFullImageView)
            appStoreFullImageView.snp.makeConstraints {
                $0.top.equalTo(appStoreFullImageContainerView.snp.top)
                $0.leading.equalTo(appStoreFullImageContainerView.snp.leading)
                $0.right.equalTo(appStoreFullImageContainerView.snp.right)
                $0.bottom.equalTo(appStoreFullImageContainerView.snp.bottom).priority(.low)
            }
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
