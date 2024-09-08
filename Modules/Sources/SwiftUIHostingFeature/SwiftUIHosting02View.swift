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

final class ViewModel02: ObservableObject {
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

struct SwiftUIHosting02View: View {
    
    @ObservedObject var viewModel: ViewModel02
    
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

#Preview {
    SwiftUIHosting02View(viewModel: ViewModel02(count: 10))
}
