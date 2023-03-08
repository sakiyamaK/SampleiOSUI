//
//  StoppableHeaderPageCollectionViewController.swift
//  SampleCollectionView
//
//  Created by  on 2021/10/22.
//

import UIKit

// 自身のタッチアクションは全て透過させるが子のタッチアクションは反応させる
class TouchTransparencyView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

final class StoppableHeaderPageCollectionViewController: UIViewController {
    private var headerView: TouchTransparencyView! = {
        let v: TouchTransparencyView = .init()
        v.backgroundColor = .systemPink
        v.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            v.heightAnchor.constraint(equalToConstant: 300),
        ]
        NSLayoutConstraint.activate(constraints)
        return v
    }()

    private var headerViewTopAnchor: NSLayoutConstraint!
    private var headerStopView: TouchTransparencyView! = {
        let v: TouchTransparencyView = .init()
        v.backgroundColor = .systemBlue
        v.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            v.heightAnchor.constraint(equalToConstant: 100),
        ]
        NSLayoutConstraint.activate(constraints)
        return v

    }()

    private var observers = [NSKeyValueObservation]()

    private var viewControllers: [UIViewController] = {
        [
            UIStoryboard(name: "DummyCollection", bundle: Bundle.module).instantiateInitialViewController()!,
            UIStoryboard(name: "DummyCollection", bundle: Bundle.module).instantiateInitialViewController()!,
            UIStoryboard(name: "DummyCollection", bundle: Bundle.module).instantiateInitialViewController()!,
        ]
    }()

    @IBOutlet private var pageScrollView: UIScrollView! {
        didSet {
            pageScrollView.delegate = self
        }
    }

    @IBOutlet private var pageStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupHeaderView()
        setupObservable(page: 0)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    deinit {
        observers.removeAll()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for (idx, collectionViewController) in viewControllers.compactMap({ $0 as? DummyCollectionViewController }).enumerated() {
            collectionViewController.scrollView.contentInset = .init(top: headerView.frame.size.height, left: 0, bottom: 0, right: 0)
            collectionViewController.reloadData(itemCount: (idx + 1) * 100)
        }
    }
}

private extension StoppableHeaderPageCollectionViewController {
    func setupHeaderView() {
        view.addSubview(headerView)
        headerView.addSubview(headerStopView)

        let headerViewTopAnchor = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        headerViewTopAnchor.priority = .init(rawValue: 999)
        let headerViewConstraints = [
            headerViewTopAnchor,
            headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerStopView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            headerStopView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ]

        self.headerViewTopAnchor = headerViewTopAnchor

        NSLayoutConstraint.activate(headerViewConstraints)
    }

    func setupStackView() {
        for viewController in viewControllers {
            let containerView = UIView()
            pageStackView.addArrangedSubview(containerView)

            addChild(viewController)
            containerView.addSubview(viewController.view)

            containerView.translatesAutoresizingMaskIntoConstraints = false
            let containerViewConstraints = [
                containerView.widthAnchor.constraint(equalTo: pageScrollView.frameLayoutGuide.widthAnchor),
                containerView.heightAnchor.constraint(equalTo: pageScrollView.frameLayoutGuide.heightAnchor),
            ]

            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            let collectionViewConstraints = [
                viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                containerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
                containerView.rightAnchor.constraint(equalTo: viewController.view.rightAnchor),
            ]

            NSLayoutConstraint.activate(containerViewConstraints + collectionViewConstraints)
        }
    }

    func setupObservable(page: Int) {
        let collectionViewControllers = viewControllers.compactMap { $0 as? DummyCollectionViewController }
        guard page >= 0, page < collectionViewControllers.count else { return }
        observers.removeAll()
        let nowCollectionViewController = collectionViewControllers[page]
        let observer = nowCollectionViewController.scrollView.observe(\.contentOffset, options: .new) { [weak self] scrollView, value in
            guard let self = self, let newValue = value.newValue else { return }
            self.headerViewTopAnchor.constant = min(0.0, -(scrollView.contentInset.top + newValue.y))
            for otherCollectionViewController in collectionViewControllers.filter({ $0 != nowCollectionViewController }) {
                otherCollectionViewController.scrollView.setContentOffset(newValue, animated: false)
            }
        }
        observers.append(observer)
    }
}

extension StoppableHeaderPageCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        setupObservable(page: page)
    }
}
