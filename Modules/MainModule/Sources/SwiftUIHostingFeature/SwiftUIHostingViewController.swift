//
//  SwiftUIHostingViewController.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2023/02/23.
//

import UIKit
import SwiftUI
import DeclarativeUIKit
import Extensions

public final class SwiftUIHostingViewController: UIViewController {

    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func setupLayout() {
        self.view.backgroundColor = .white
        self.declarative {
            UIView()
                .apply { [weak self] in
                    self?.addContainer(viewController: UIHostingController(rootView: Text("hogeeee").foregroundColor(.black)), containerView: $0)
                }
        }
    }
}

// struct SwiftUIHostingViewController_Wrapper: UIViewControllerRepresentable {
//    typealias UIViewControllerType = SwiftUIHostingViewController
//
//    func makeUIViewController(context: Context) -> UIViewControllerType {
//        let vc = UIViewControllerType()
//        return vc
//    }
//
//    func updateUIViewController(_ vc: UIViewControllerType, context: Context) {
//    }
// }
//
// struct SwiftUIHostingViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            SwiftUIHostingViewController_Wrapper()
//        }
//    }
// }
