//
//  DeclarativeUIKitViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/12/22.
//

import UIKit
import DeclarativeUIKit

final class DeclarativeUIKitViewController: UIViewController {
    enum State {
        case first, second
    }

    var state: State = .first

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        update()
    }

    private func update() {
        build {
            UIStackView.vStack {
                UIStackView.hStack {
                    if state == .first {
                        UILabel.build {
                            guard let label = $0 as? UILabel else { return }
                            label.text = "宣言的じゃないですか！！！"
                            label.textAlignment = .center
                            label.numberOfLines = 1
                            label.heightConstraint = 100
                        }
                        UIView.spacer()
                    } else {
                        UIView.spacer()
                        UILabel.build {
                            guard let label = $0 as? UILabel else { return }
                            label.text = "宣言的なんですね！！！"
                            label.textAlignment = .center
                            label.textColor = .systemTeal
                            label.numberOfLines = 1
                            label.heightConstraint = 100
                        }
                    }
                }
                UIView.spacer(height: 100)
                UIStackView.vStack(alignment: .center) {
                    UIButton.build {
                        guard let button = $0 as? UIButton else { return }
                        button.backgroundColor = .black
                        button.setTitle("ここを押したらレイアウトが変わるよ", for: .normal)
                        button.setTitleColor(.white, for: .normal)
                        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
                        button.heightConstraint = 100
                    }.circle(radius: 10)
                }
            }
        }
    }
}

@objc extension DeclarativeUIKitViewController {
    func tapButton(_: UIButton) {
        state = state == .first ? .second : .first
        update()
    }
}
