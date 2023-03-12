//
//  SwiftUIHostingViewController.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2023/02/23.
//

import UIKit
import SwiftUI
import Combine
import DeclarativeUIKit
import Extensions

private final class ViewModel: ObservableObject {
    
    @Published var text: String = "ここが変わるよ"
    let buttonTitle = "ボタンです"
    
    func tapAction() {
        DLog("タップ")
        text = "変わったよ"
    }
}

private struct SwiftUIHostingView: View {
    
    @ObservedObject var viewModel: ViewModel

        var body: some View {
            Text(self.viewModel.text)
            Button(self.viewModel.buttonTitle) {
                self.viewModel.tapAction()
            }
        }
}

public final class SwiftUIHosting01ViewController: UIViewController {

    private let viewModel = ViewModel()
    
    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }
        
    @objc func setupLayout() {
        self.addHostingController(
            rootView: SwiftUIHostingView(viewModel: viewModel),
            containerView: self.view
        )        
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
