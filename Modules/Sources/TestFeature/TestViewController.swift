//
//  CoreLibraries.swift
//
//
//  Created by sakiyamaK on 2024/08/24.
//

import UIKit
import DeclarativeUIKit
import ObservableUIKit
import UITextView_Placeholder

public extension UITextView {
    func placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
}

final class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.declarative(layoutGuides: .init(all: .margins)) {
            UITextView()
                .placeholder("hogehoge")
            //            UIButton(configuration: UIButton.Configuration.bordered().title("ボタンです"))
        }
//        .applyView {
//            $0.layoutMargins(UIEdgeInsets.zero)
//        }
    }

    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            let trait = view.traitCollection
            // 向きに応じた処理
            if trait.horizontalSizeClass == .compact && trait.verticalSizeClass == .regular {
                print("|")
            } else if trait.horizontalSizeClass == .regular && trait.verticalSizeClass == .compact {
                print("-")
            }
        }
}

#Preview {
    TestViewController()
}
