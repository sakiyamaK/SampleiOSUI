//
//  SampleTableViewController.swift
//  SampleiOSUI
//
//  Created by  on 2021/3/26.
//

import RxCocoa
import RxSwift
import UIKit

public final class SampleTableViewController: UIViewController {
    public static func make() -> SampleTableViewController {
        let storyboard = UIStoryboard(name: "SampleTable", bundle: Bundle.module)
        let vc = storyboard.instantiateInitialViewController()
        let res = vc as! SampleTableViewController
        return res
    }
    
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        //        tableView.rx.itemMoved
    }
}

extension SampleTableViewController: UITableViewDelegate {}

extension SampleTableViewController: UITableViewDataSource {
    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        10
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = indexPath.item.description
        cell.contentView.backgroundColor = .systemBlue
        return cell
    }

    public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        100
    }
}
