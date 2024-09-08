//
//  AppStoreFullImageCell.swift
//  SampleCompositonalLayout
//
//  Created by sakiyamaK on 2021/04/09.
//

import Extensions
import UIKit

protocol AppStoreFullImageViewDelegate: AnyObject {
    func toucheStart()
    func toucheEnd(sampleModel: SampleImageModel2, heroId: String?)
    func tapCloseButton()
}

final class AppStoreFullImageView: UIView {
    @IBOutlet private(set) var backgroundImageView: UIImageView!
    @IBOutlet private var appIconImageView: UIImageView!
    @IBOutlet private var appButton: UIButton!
    @IBOutlet private var closeButton: UIButton!

    private(set) var sampleModel: SampleImageModel2!
    weak var delegate: AppStoreFullImageViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        awake()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    func configure(sample: SampleImageModel2, heroId: String? = nil, isFullScreenMode: Bool) {
        sampleModel = sample
        backgroundImageView.image = sample.image
        appIconImageView.image = sample.subImage
        if let heroId = heroId {
            backgroundImageView.heroID = heroId
        }
        setup(isFullScreenMode: isFullScreenMode)
    }
}

private extension AppStoreFullImageView {
    @objc
    func tapCloseButton(sender _: UIButton) {
        delegate?.tapCloseButton()
    }

    func awake() {
        backgroundImageView.isHeroEnabled = true
        appIconImageView.clipsToBounds = true
        appIconImageView.layer.cornerRadius = 8
        closeButton.addTarget(self, action: #selector(tapCloseButton(sender:)), for: .touchUpInside)
    }

    func layout() {
        appButton.clipsToBounds = true
        appButton.layer.cornerRadius = appButton.frame.height / 2
    }

    func reset() {
        backgroundImageView.image = nil
    }

    func setup(isFullScreenMode: Bool = false) {
        if isFullScreenMode {
            layer.cornerRadius = 0
            clipsToBounds = false
            closeButton.isHidden = false
        } else {
            layer.cornerRadius = 10
            clipsToBounds = true
            closeButton.isHidden = true
        }
    }
}

final class AppStoreFullImageCell: UICollectionViewCell {
    private lazy var mainView: AppStoreFullImageView! =
        UINib(nibName: "AppStoreFullImageView", bundle: Bundle.module).instantiate(withOwner: self, options: nil).first as? AppStoreFullImageView

    var reuseHeroId: String? { mainView.backgroundImageView.heroID }
    var sampleModel: SampleImageModel2 { mainView.sampleModel }
    var delegate: AppStoreFullImageViewDelegate? {
        set {
            mainView.delegate = newValue
        }
        get {
            mainView.delegate
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainView)
        mainView.applyArroundConstraint(equalTo: self)
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 4
        isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.mainView.transform = .init(scaleX: 0.9, y: 0.9)
            self.delegate?.toucheStart()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.mainView.transform = .identity
            self.delegate?.toucheEnd(sampleModel: self.sampleModel, heroId: self.reuseHeroId)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mainView.reset()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(sample: SampleImageModel2) {
        mainView.configure(sample: sample, heroId: UUID().uuidString, isFullScreenMode: false)
    }
}
