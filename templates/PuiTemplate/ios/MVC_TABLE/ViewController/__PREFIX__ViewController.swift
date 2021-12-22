//
//  __PREFIX__ViewController.swift
//  __TARGET__
//
//  Created by __USERNAME__ on __YEAR__/__MONTH__/__DAY__.
//

import UIKit

final class __PREFIX__ViewController: UIViewController {

  @IBOutlet private weak var tableView: UITableView! {
    didSet {
    }
  }
}

extension __PREFIX__ViewController: UITableViewDelegate {
}

extension __PREFIX__ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
}