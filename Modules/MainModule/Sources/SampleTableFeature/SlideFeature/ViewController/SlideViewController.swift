//
//  SlideViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/3/25.
//

import UIKit

public final class SlideViewController: UIViewController {
    public static func make() -> SlideViewController {
        UIStoryboard(name: "Slide", bundle: Bundle.module).instantiateInitialViewController() as! SlideViewController
    }
    @IBOutlet private var widthConstraint: NSLayoutConstraint!

    private var touchStartLocation: CGPoint?
    private var startConstraint: CGFloat?

    public override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        //        print(touches.first?.location(in: view))
        touchStartLocation = touches.first?.location(in: view)
        startConstraint = widthConstraint.constant
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        guard
            let startLocation = touchStartLocation,
            let startConstraint = startConstraint,
            let nowLocation = touches.first?.location(in: view)
        else {
            return
        }
        let moveX = nowLocation.x - startLocation.x

        print(moveX)

        widthConstraint.constant = startConstraint + moveX
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }

    public override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        touchStartLocation = nil
    }
}
