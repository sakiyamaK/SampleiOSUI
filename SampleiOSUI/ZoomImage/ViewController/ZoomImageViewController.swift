//
//  ZoomImageViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/6/17.
//

import UIKit

final class ZoomImageViewController: UIViewController {
    @IBOutlet private weak var contentView: UIView!
}

extension ZoomImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentView
    }
}
