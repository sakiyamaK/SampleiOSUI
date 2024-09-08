// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit
//import SwiftUI
import RswiftResources

//struct MySwiftUIView: View {
//    var body: some View {
////        Image(R.image(bundle: .module).aho)
////            .resizable()
////            .aspectRatio(contentMode: .fill)
//    }
//}

private extension UIView {
    @discardableResult
    func apply(constraints: [NSLayoutConstraint]) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        return self
    }
}

final class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var config = UIButton.Configuration.filled()
        config.title = "SwiftUIの画面を呼ぶよ"
        let button = UIButton(configuration: config)
        button.addAction(.init(handler: { _ in
            // SwiftUIの画面へ遷移
//            let nextVC = UIHostingController(rootView: MySwiftUIView())
//            self.navigationController?.pushViewController(nextVC, animated: true)
        }), for: .touchUpInside)
        
        view.addSubview(button)
        button.apply(constraints: [
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

#Preview {
    UINavigationController(rootViewController: TestViewController())
//    MySwiftUIView().viewController
//    MySwiftUIView()
}



