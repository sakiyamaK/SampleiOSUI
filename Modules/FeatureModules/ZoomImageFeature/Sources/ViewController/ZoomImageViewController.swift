//
//  ZoomImageViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/6/17.
//

import UIKit
import Extensions

public final class ZoomImageViewController: UIViewController {
        
    @IBOutlet private var contentView: UIView!
}

extension ZoomImageViewController: UIScrollViewDelegate {
    public func viewForZooming(in _: UIScrollView) -> UIView? {
        contentView
    }
}

#Preview {
    ZoomImageViewController.makeFromStroryboard(name: "ZoomImage", bundle: .module)!
}
