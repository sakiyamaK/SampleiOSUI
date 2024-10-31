//
//  UserDetail2ViewController.swift
//  
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit
import Utils
import ObservableUIKit
import Kingfisher

public protocol UserDetail2View: UIView {
    func setup(presenter: UserDetail2Presenter)
}

public final class UserDetail2ViewImpl: UIView, UserDetail2View {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { print("\(Self.self) deinit") }

    private var presenter: UserDetail2Presenter!
    
    private lazy var imageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        return imageView
    }()
    
    private var activityIndicatorView: UIActivityIndicatorView = .init(style: .large)
    
    init() {
        super.init(frame: .zero)
    }
        
    public func setup(presenter: UserDetail2Presenter) {
        self.presenter = presenter
        self.setupUI()
        self.setupObservation()
    }

    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

    }
    
    private func setupObservation() {
        imageView
            .observation(
                tracking: {[weak self] in
                    self!.presenter.user
                },
                onChange: { imageView, user in
                    let url = URL(string: user.picture.large!)!
                    imageView.kf.setImage(with: url)
                }
            )
    }
}

#Preview {

    MainActor.assumeIsolated {
        {() -> UIViewController in
            if let user = User.dummyUsers.first {
                return UserDetail2RouterImpl.assembleModules(user: user)
            } else {
                print("ユーザが見つかりません")
                return UIViewController()
            }
        }()
    }
}
