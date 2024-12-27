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
        
        self.declarative {
            UITextView()
                .placeholder("hogehoge")
//            UIButton(configuration: UIButton.Configuration.bordered().title("ボタンです"))
        }
    }
}

#Preview {
    TestViewController()
}
