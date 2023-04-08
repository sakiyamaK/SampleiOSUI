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

public class SampleTextViewController: UIViewController, UITextViewDelegate {
    private weak var textView: UITextView!
    private weak var circleView: UIView!

    private var centerXConst: NSLayoutConstraint!
    private var centerYConst: NSLayoutConstraint!
    
    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)

        setupLayout()
    }


    @objc func setupLayout() {
        self.view.backgroundColor = .white

        self.declarative {
            UITextView(assign: &textView)
                .apply({
                    $0.textStorage.replaceCharacters(in: NSRange(location: 0, length: 0), with: """
我々は一人の英雄を失った。しかし、これは敗北を意味するのか？否！始まりなのだ！
地球連邦に比べ、我がジオンの国力は30分の1以下である。
にもかかわらず今日まで戦い抜いてこられたのは何故か？
諸君！我がジオン公国の戦争目的が正義だからだ。これは諸君らが一番知っている。
我々は地球を追われ、宇宙移民者にさせられた。
そして、一握りのエリートらが宇宙にまで膨れ上がった地球連邦を支配して50余年、
宇宙に住む我々が自由を要求して何度踏みにじられたか。
ジオン公国の掲げる人類一人一人の自由のための戦いを神が見捨てるはずはない。
私の弟！諸君らが愛してくれたガルマ・ザビは死んだ。
何故だ！？
新しい時代の覇権を選ばれた国民が得るは、歴史の必然である。
ならば、我らは襟を正し、この戦局を打開しなければならぬ。
我々は過酷な宇宙空間を生活の場としながらも共に苦悩し、錬磨して今日の文化を築き上げてきた。
かつて、ジオン・ダイクンは人類の革新は宇宙の民たる我々から始まると言った。
しかしながら地球連邦のモグラ共は、自分たちが人類の支配権を有すると増長し我々に抗戦する。
諸君の父も、子もその連邦の無思慮な抵抗の前に死んでいったのだ！
この悲しみも怒りも忘れてはならない！それを、ガルマは！死をもって我々に示してくれた！
我々は今、この怒りを結集し、連邦軍に叩きつけて、初めて真の勝利を得ることができる。
この勝利こそ、戦死者全てへの最大の慰めとなる。
国民よ立て！悲しみを怒りに変えて、立てよ！国民よ！
我らジオン国国民こそ選ばれた民であることを忘れないでほしいのだ。
優良種である我らこそ人類を救い得るのである。ジーク・ジオン！
""")
                    
                    $0.layoutManager.usesDefaultHyphenation = true
                })
                .delegate(self)
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
    
        
    @objc func circlePan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: view)
        centerXConst.constant = translation.x
        centerYConst.constant = translation.y
        updateExclusionPaths()
    }
    
    func updateExclusionPaths() {
        var ovalFrame = textView.convert(circleView.bounds, from: circleView)
        
        ovalFrame.origin.x -= textView.textContainerInset.left
        ovalFrame.origin.y -= textView.textContainerInset.top
        
        let ovalPath = UIBezierPath(ovalIn: ovalFrame)
        textView.textContainer.exclusionPaths = [ovalPath]
    }
}
