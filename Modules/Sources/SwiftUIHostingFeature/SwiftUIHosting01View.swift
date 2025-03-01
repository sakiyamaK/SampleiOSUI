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

final class ViewModel01: ObservableObject {

    @Published var text: String = "ここが変わるよ"
    let buttonTitle = "ボタンです"

    func tapAction() {
        DLog("タップ")
        text = "変わったよ"
    }
}

struct SwiftUIHosting01View: View {

    @ObservedObject var viewModel: ViewModel01

    @MainActor
    enum EdgeInsets {
        static let top: CGFloat = custom(10)
        static let left: CGFloat = custom(2)
        static let right: CGFloat = custom(2)
//        @MainActor
        public static let custom: (CGFloat) -> CGFloat = { $0 }
    }


    var body: some View {
        Text("Hello, World!")
        .padding([.top], EdgeInsets.top)
            .padding([.leading, .trailing], EdgeInsets.left)
    }
}

#Preview {
    SwiftUIHosting01View(viewModel: ViewModel01())
}
