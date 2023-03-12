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
    let buttonTitle = "ボタンです"
    
    var count: Int
    @Published var texts: [String]
    
    init(count: Int) {
        self.count = count
        self.texts = Array(repeating: "ここが変わるよ", count: 100)
    }
    
    func tapAction(index: Int) {
        DLog("タップ")
        self.texts[index] = "変わったよ"
    }
}

private struct SwiftUIHostingView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(content: {
            LazyVStack {
                ForEach(0..<viewModel.count, id: \.self) { i in
                    Text(self.viewModel.texts[i])
                    Button(self.viewModel.buttonTitle) {
                        self.viewModel.tapAction(index: i)
                    }
                    .onAppear() {
                        DLog(i)
                    }
                    Spacer(minLength: 20)
                }
            }
        })
    }
}

public final class SwiftUIHosting03ViewController: UIViewController {
    
    private let viewModel = ViewModel(count: 100)
    
    public override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLayout),
                                               name: Notification.Name.injection, object: nil)
        setupLayout()
    }
    
    @objc func setupLayout() {
        
        self.view.backgroundColor = .white
        
        self.declarative {
            UIStackView.vertical {
                UILabel("UIStackViewの中にあるUILabelです")
                    .textAlignment(.center)
                    .contentPriorities(.init(vertical: .required))
                    .customSpacing(20)
                
                UIView().apply {
                    self.addHostingController(
                        rootView:
                            ScrollView(content: {
                                LazyVStack {
                                    ForEach(1...100, id: \.self) { i in
                                        UILabel("ScrollView > LazyVStackの中にある\n\(i)番目のUILabelです")
                                            .textAlignment(.center)
                                            .numberOfLines(0)
                                            .contentPriorities(.init(vertical: .required))
                                            .toView()
                                            .onAppear() {
                                                DLog(i)
                                            }
                                    }
                                }
                            }),
                        containerView: $0
                    )
                }
            }
        }
    }
}

//public final class SwiftUIHosting02ViewController: UIViewController {
//
//    private let viewModel = ViewModel(count: 100)
//
//    public override func loadView() {
//        super.loadView()
//
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(setupLayout),
//                                               name: Notification.Name.injection, object: nil)
//        setupLayout()
//    }
//
//    @objc func setupLayout() {
//        self.addHostingController(
//            rootView: SwiftUIHostingView(viewModel: viewModel),
//            containerView: self.view
//        )
//    }
//}

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
