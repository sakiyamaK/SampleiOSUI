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

        var body: some View {
            Text(self.viewModel.text)
            Button(self.viewModel.buttonTitle) {
                self.viewModel.tapAction()
            }
        }
}

#Preview {
    SwiftUIHosting01View(viewModel: ViewModel01())
}
