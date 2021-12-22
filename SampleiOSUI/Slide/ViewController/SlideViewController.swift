//
//  SlideViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/3/25.
//

import UIKit

final class SlideViewController: UIViewController {

    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!

    private var touchStartLocation: CGPoint?
    private var startConstraint: CGFloat?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches.first?.location(in: self.view))
        touchStartLocation = touches.first?.location(in: self.view)
        startConstraint = widthConstraint.constant
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let startLocation = touchStartLocation,
            let startConstraint = startConstraint,
            let nowLocation = touches.first?.location(in: self.view) else {
            return
        }
        let moveX = nowLocation.x - startLocation.x

        print(moveX)

        widthConstraint.constant = startConstraint + moveX
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchStartLocation = nil
    }
}
