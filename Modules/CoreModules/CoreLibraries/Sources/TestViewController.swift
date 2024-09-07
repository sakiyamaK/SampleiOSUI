//
//  CoreLibraries.swift
//  
//
//  Created by sakiyamaK on 2024/08/24.
//

import UIKit
import DeclarativeUIKit
import ObservableUIKit

final class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.declarative {
            UIButton(configuration: UIButton.Configuration.bordered().title("ボタンです"))
                .center()
        }
    }
}

#Preview {
    TestViewController()
}
