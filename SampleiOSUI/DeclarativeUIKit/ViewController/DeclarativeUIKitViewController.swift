//
//  DeclarativeUIKitViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/12/22.
//

import UIKit

final class DeclarativeUIKitViewController: UIViewController {

    enum State {
        case first, second
    }

    var state: State = .first

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.update()

    }

    private func update() {

        self.view.subviews.forEach({$0.removeFromSuperview()})

        self.build(
            UIStackView.vStack {
                UIStackView.hStack {
                    UIView.build {
                        $0.backgroundColor = .systemBlue
                        $0.widthConstraint = 100
                        $0.heightConstraint = 100
                        $0.isHidden = state == .first
                    }
                    UIView.space()
                    UIView.build {
                        $0.backgroundColor = .systemPink
                        $0.widthConstraint = 100
                        $0.heightConstraint = 100
                        $0.isHidden = state == .first
                    }
                }
                UILabel.build {
                    guard let label = $0 as? UILabel else { return }
                    label.text = "宣言的じゃないですか！！！"
                    label.textAlignment = .center
                    label.numberOfLines = 1
                    $0.isHidden = state == .first
                    label.heightConstraint = 100
                }
                UIView.space(height: 100)
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
                UILabel.build {
                    guard let label = $0 as? UILabel else { return }
                    label.text = "はみだしたら勝手にスクロールするんですね！！！"
                    label.textAlignment = .center
                    label.numberOfLines = 1
                    label.heightConstraint = 300
                    $0.isHidden = state == .first
                }
                UIView.build {
                    $0.backgroundColor = .green
                    $0.heightConstraint = 200
                    $0.isHidden = state == .first
                }
            }
        )
    }
}

@objc extension DeclarativeUIKitViewController {
    func tapButton(_ sender: UIButton) {
        self.state = state == .first ? .second : .first
        self.update()
    }
}
