//
//  TestViewController.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2021/12/03.
//

import UIKit

final class TestViewController: UIViewController {
    static func makeFromStoryBoard() -> TestViewController {
        let vc = UIStoryboard(name: "Test", bundle: nil).instantiateInitialViewController() as! TestViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
