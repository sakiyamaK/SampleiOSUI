//
//  SampleTableViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/3/26.
//

import UIKit

final class SampleTableViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        }
    }
}

extension SampleTableViewController: UITableViewDelegate {
}

extension SampleTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = indexPath.item.description
        cell.contentView.backgroundColor = .systemBlue
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
