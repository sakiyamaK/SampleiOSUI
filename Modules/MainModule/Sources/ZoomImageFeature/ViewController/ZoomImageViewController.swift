//
//  ZoomImageViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/6/17.
//

import UIKit

public final class ZoomImageViewController: UIViewController {
    public static func make() -> ZoomImageViewController {
        let storyboard = UIStoryboard(name: "ZoomImage", bundle: Bundle.module)
        let vc = storyboard.instantiateInitialViewController()
        let res = vc as! ZoomImageViewController
        return res
    }
        
    @IBOutlet private var contentView: UIView!
}

extension ZoomImageViewController: UIScrollViewDelegate {
    public func viewForZooming(in _: UIScrollView) -> UIView? {
        contentView
    }
}
