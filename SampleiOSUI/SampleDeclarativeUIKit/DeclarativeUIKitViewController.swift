//
//  DeclarativeUIKitViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/12/22.
//

import DeclarativeUIKit
import UIKit

final class SimpleViewController: UIViewController {
    enum ViewTag: Int {
        case button = 1, tapLabel
    }
    
    private weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(update),
                                               name: Notification.Name("INJECTION_BUNDLE_NOTIFICATION"), object: nil)
        
        update()
    }
    
    @objc func update() {
        view.backgroundColor = .white
        
        let Border = {
            UIView.divider().backgroundColor(.gray)
        }
        
        let Header = { (title: String) -> UIView in
            UIStackView.vertical {
                UILabel(title)
                    .textColor(.black)
                    .textAlignment(.center)
                    .numberOfLines(0)
                    .font(UIFont.systemFont(ofSize: 30))
                UIView.spacer().height(10)
                Border()
            }
        }
        
        let ScrollBlocksView = {
            UIScrollView.horizontal(margin: .init(top: 20, left: 10, bottom: 20, right: 10)) {
                UIStackView.horizontal(distribution: .fill) { stackView in
                    UIView()
                        .imperative { _ in
                            print(stackView)
                        }
                        .width(100)
                        .height(100)
                        .backgroundColor(.red)
                    UIView()
                        .width(100)
                        .aspectRatio(1.0)
                        .backgroundColor(.green)
                        .cornerRadius(30, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
                    UIView()
                        .size(width: 100, height: 100)
                        .border(color: .blue, width: 10)
                    UIView()
                        .size(width: 100, height: 100)
                        .backgroundColor(.black)
                        .transform(.init(rotationAngle: 45.0 / 360 * Double.pi))
                    UIView.imperative {
                        $0.heightConstraint = 100
                        $0.widthConstraint = 100
                        $0.backgroundColor = .systemRed
                    }
                    .shadow(color: .black.withAlphaComponent(0.8), radius: 10, x: 5, y: 5)
                    
                    UIView()
                        .backgroundColor(.systemRed)
                        .padding()
                        .backgroundColor(.systemYellow)
                        .size(width: 100, height: 100)
                    
                }.spacing(20)
            }
            .showsScrollIndicator(false)
        }
        
        let CenteringView = {
            UIStackView.horizontal {
                UIStackView.vertical {
                    UIImageView(UIImage(systemName: "square.and.arrow.up"))
                        .contentMode(.scaleAspectFit)
                        .height(200)
                    
                    UIButton(assign: &self.button)
                        .title("button", for: .normal)
                        .titleColor(.brown, for: .normal)
                        .addControlAction(target: self, for: .touchUpInside) {
                            #selector(self.tapButton)
                        }
                    
                    UILabel("タップジェスチャーのあるラベル")
                        .textAlignment(.center)
                        .isUserInteractionEnabled(true)
                        .addGestureRecognizer {
                            UITapGestureRecognizer(target: self) {
                                #selector(self.tapLabel(_:))
                            }
                        }
                }
                .spacing(30)
            }
            .alignment(.center)
        }
        
        let ZStackView = {
            UIStackView.horizontal {
                UIImageView(UIImage(systemName: "square.and.arrow.down"))
                    .height(200)
                    .contentMode(.scaleAspectFit)
                    .zStack(margin: .init(top: 70, left: 10, bottom: 0, right: 10)) {
                        UILabel("上に重なってるね")
                            .textColor(.black)
                            .textAlignment(.center)
                            .font(UIFont.boldSystemFont(ofSize: 30))
                    }
            }.alignment(.center)
        }
        
        let SomeViews = {
            Array(1 ... 10).compactMap { num in
                UILabel("\(num)番目のlabel")
                    .textColor(.black)
                    .textAlignment(.center)
            }
        }
        
        declarative {
            UIScrollView.vertical {
                UIStackView.vertical {
                    Header("UIViewの設定")
                    UIView.spacer().height(20)
                    ScrollBlocksView()
                    UIView.spacer().height(20)
                    CenteringView()
                    UIView.spacer().height(20)
                    ZStackView()
                    UIView.spacer().height(30)
                    SomeViews()
                    UIView.spacer().height(20)
                }
            }
            .refreshControl {
                UIRefreshControl()
                    .addControlAction(target: self, for: .valueChanged) {
                        #selector(refresh)
                    }
            }
        }
    }
}

@objc private extension SimpleViewController {
    func tapLabel(_: UIGestureRecognizer) {
        print("ラベルをタップしたね")
    }
    
    func tapButton(_: UIButton) {
        print("ボタンをタップしたね")
    }
    
    func refresh(_: UIRefreshControl) {
        print("refresh")
    }
}

final class DeclarativeUIKitViewController: UIViewController {
    enum State {
        case first, second
    }
    
    var state: State = .first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(update),
                                               name: Notification.Name("INJECTION_BUNDLE_NOTIFICATION"), object: nil)
        update()
    }
    
    @objc
    func update() {
        view.backgroundColor = .white
        
        declarative {
            UIView().backgroundColor(.black)
        }
    }
}

extension DeclarativeUIKitViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .red
        return cell
    }
}

import SwiftUI

private struct ViewController_Wrapper: UIViewControllerRepresentable {
    typealias ViewController = DeclarativeUIKitViewController
    
    func makeUIViewController(context _: Context) -> ViewController {
        let vc = ViewController()
        return vc
    }
    
    func updateUIViewController(_: ViewController, context _: Context) {}
}

struct SimpleViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ViewController_Wrapper()
        }
    }
}
