//
//  CustomNavigationBar.swift
//
//
//  Created by sakiyamaK on 2024/04/03.
//

import UIKit

public final class CustomNavigationBar: UINavigationBar {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        print("aa")
        self.declarative {
            UIStackView.vertical({
                UILabel(NSAttributedString(string: "うおおお", attributes: UINavigationBarAppearance().titleTextAttributes))
                    .textAlignment(.center)
                    .contentPriorities(.init(all: .required))
                UIStackView.horizontal {
                    (0..<3).compactMap { index in
                        UIButton(type: .system)
                            .title("tab \(index)")
                            .titleColor(.black)
                            .addAction(.touchUpInside) { _ in
                                print(index)
                            }
                    }
                }
                .distribution(.fillEqually)
            })
            .backgroundColor(.white)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        print("bb")
    }
}
