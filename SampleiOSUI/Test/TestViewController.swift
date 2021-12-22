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

    @IBOutlet private weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        button.setTitle(nil, for: .normal)

        print(button.titleLabel?.text)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(button.titleLabel?.text)
    }
}
