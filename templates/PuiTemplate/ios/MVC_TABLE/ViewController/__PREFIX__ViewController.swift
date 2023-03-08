//
//  __PREFIX__ViewController.swift
//  __TARGET__
//
//  Created by __USERNAME__ on __YEAR__/__MONTH__/__DAY__.
//

import UIKit

final class __PREFIX__ViewController: UIViewController {
  @IBOutlet private var tableView: UITableView! {
    didSet {}
  }
}

extension __PREFIX__ViewController: UITableViewDelegate {}

extension __PREFIX__ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    0
  }

  func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
}
