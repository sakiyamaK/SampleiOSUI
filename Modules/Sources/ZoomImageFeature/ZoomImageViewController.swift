//
//  ZoomImageViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/6/17.
//

import UIKit
import Extensions
import DeclarativeUIKit
//import Files

public final class ZoomImageViewController: UIViewController {
        
    public static func make() -> ZoomImageViewController {
        ZoomImageViewController.makeFromStroryboard(name: "ZoomImage", bundle: .module)!
    }
    
    @IBOutlet private var contentView: UIView! {
        didSet {
            contentView.declarative {
                UILabel("text")
                    .textColor(.white)
                    .textAlignment(.center)
                    .font(.defaultFontBold(size: 28))
//                UIImageView(R.image(bundle: .module).aho()!)
//                    .contentMode(.scaleAspectFit)
            }
        }
    }
}

extension ZoomImageViewController: UIScrollViewDelegate {
    public func viewForZooming(in _: UIScrollView) -> UIView? {
        contentView
    }
}

#Preview {
    ZoomImageViewController.makeFromStroryboard(name: "ZoomImage", bundle: .module)!
}
