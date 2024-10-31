//
//  UserTab2ViewController.swift
//  
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit
import Utils
import ObservableUIKit
import Kingfisher

public protocol UserTab2View: UIView {
    func setup(presenter: UserTab2Presenter)
}
