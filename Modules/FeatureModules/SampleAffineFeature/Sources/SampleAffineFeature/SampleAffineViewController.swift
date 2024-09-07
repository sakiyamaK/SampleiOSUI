//
//  SampleAffineViewController.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2022/08/07.
//

import DeclarativeUIKit
import UIKit
import Extensions

extension Bundle {
    static var current: Bundle {
        class DummyClass{}
        return Bundle(for: type(of: DummyClass()))
    }
}
public final class SampleAffineViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
//        let range = (0 ... 10)
//        let count = range.count
        
        applyView {
            $0.backgroundColor(.white)
        }.declarative {
//            UIScrollView.vertical {
                UIStackView.vertical {
                    
                    UIImageView(UIImage(named: "lufyA", in: Bundle.current, with: nil))
                        .contentMode(.scaleAspectFit)
                        .backgroundColor(.red)
                    
                    UIImageView(UIImage(named: "lufyB", in: Bundle.current, with: nil))
                        .contentMode(.scaleAspectFit)
                        .backgroundColor(.green)
                    
                    UIImageView(UIImage(named: "lufyC", in: Bundle.current, with: nil))
                        .contentMode(.scaleAspectFit)
                        .backgroundColor(.blue)
                    
                    UIImageView(UIImage(resource: .lufyC))
                        .contentMode(.scaleAspectFit)
                        .backgroundColor(.red)
                    
                    
                    //                UIStackView.horizontal {
                    //                    range.compactMap { num in
                    //
                    //                        UIImageView(UIImage(named: "lufyA", in: Bundle.module, with: .none))
                    //                            .contentMode(.scaleAspectFit)
                    //                            .backgroundColor(num == count / 2 ? .systemRed : .systemGray)
                    //                            .width(UIScreen.main.bounds.width / CGFloat(count))
                    //                            .aspectRatio(1.0)
                    //                            .apply {
                    //                                let dNum = Double(num)
                    //                                let dCount = Double(count - 1)
                    //                                let v: Double = (dNum * 2 / dCount) - 1
                    //                                let angle: Double = v * 0.48 * Double.pi
                    //                                $0.transform3D = CATransform3DRotate(CATransform3DIdentity, angle, 0, 1, 0)
                    //                            }
                    //                            .shadow(color: .black, radius: 10, x: 1, y: 1)
                    //                    }
                    //                }
                    //                .alignment(.center)
                }
                .distribution(.fillEqually)
                .center()
//            }
        }
    }
}

#Preview {
    SampleAffineViewController()
}
