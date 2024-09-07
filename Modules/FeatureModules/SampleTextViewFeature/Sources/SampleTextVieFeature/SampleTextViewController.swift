//
//  SampleTextViewController.swift
//  
//
//  Created by sakiyamaK on 2023/04/08.
//

import UIKit
import DeclarativeUIKit
import Extensions
import Components

// 円をドラッグしたらUITextViewの文字列が避けるように配置される

public class SampleTextViewController: UIViewController {
    private weak var textView: UITextView!
    private weak var circleView: UIView!

    private var centerXConst: NSLayoutConstraint!
    private var centerYConst: NSLayoutConstraint!
    
    public override func loadView() {
        super.loadView()

        // ホットリロードさせるメソッドを設定
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(circlePan),
                                               name: Notification.Name.injection, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateExclusionPaths),
                                               name: Notification.Name.injection, object: nil)

        setupLayout()
    }
}

@objc private extension SampleTextViewController {
    func setupLayout() {
        self.view.backgroundColor = .white

        self.declarative {
            UITextView(assign: &textView)
                .apply({
                    $0.textStorage.replaceCharacters(in: NSRange(location: 0, length: 0), with: SampleTextContents.sample01)
                  
                    //これを設定しないとテキストのレイアウトが動かない
                    $0.layoutManager.usesDefaultHyphenation = true
                })
        }

        //中心に配置するレイアウトがDeclarativeUIKitが未対応だったので既存の貼り方

        self.view.addSubview(
            UIView(assign: &circleView)
        )

        circleView.translatesAutoresizingMaskIntoConstraints = false

        //DeclarativeUIKitでパラメータの設定だけはできるから宣言的に書く
        circleView
            .size(width: 200, height: 200)
            .cornerRadius(100)
            .backgroundColor(.systemBlue)
            .isUserInteractionEnabled(true)
            .addGestureRecognizer({
                UIPanGestureRecognizer(target: self, action: #selector(circlePan(_:)))
            })
            .zStack({
                UILabel("Drag me!")
                    .textColor(.white)
                    .contentPriorities(.init(all: .required))
                    .center()
            })
        //DeclarativeUIKitでこのセンター揃えが未対応のままだった
        centerXConst = circleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        centerXConst.isActive = true
        centerYConst = circleView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        centerYConst.isActive = true
    }
    
        
    func circlePan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: view)
        centerXConst.constant = translation.x
        centerYConst.constant = translation.y
        updateExclusionPaths()
    }
    
    func updateExclusionPaths() {
        var ovalFrame = textView.convert(circleView.bounds, from: circleView)
        ovalFrame.origin.x -= textView.textContainerInset.left
        ovalFrame.origin.y -= textView.textContainerInset.top
        
        // 円形のパスを取得
        let ovalPath = UIBezierPath(ovalIn: ovalFrame)
        // 指定したパスを避けてテキストをレイアウトする
        textView.textContainer.exclusionPaths = [ovalPath]
    }
}

#Preview {
    SampleTextViewController()
}
