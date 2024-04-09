//
//  NavigationTabView.swift
//
//
//  Created by sakiyamaK on 2024/04/08.
//

import UIKit

public class NavigationTabView: UIView, ScrollNavigationTabBarPageTabViewProtocol {

    public weak var navigationTabBarScrollView: UIScrollView!
    public var tap: ((Int) -> Void)?

    struct Parameter {
        let buttons: [UIView]
        let bar: UIView
    }
    
    private var barWidthConst: NSLayoutConstraint!
    private var barLeftConst: NSLayoutConstraint!
    private var parameter: Parameter!
    
    convenience init(
        parameter: Parameter
    ) {
        self.init(frame: .zero)
        
        self.parameter = parameter
        
        parameter.buttons.enumerated().forEach { (index, button) in
            button.add(gestureRecognizer: UITapGestureRecognizer(target: self, {[weak self] _ in
                guard let self else { return }
                self.tap?(index)
            }))
        }
        
        self.backgroundColor(.green)
            .declarative {
                UIScrollView.horizontal {
                    UIStackView.horizontal {
                        parameter.buttons
                    }
                }.assign(to: &navigationTabBarScrollView)
            }
        
        if parameter.buttons.first != nil {
            let bar = parameter.bar
            bar.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(bar)
            bar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            barLeftConst = bar.leftAnchor.constraint(equalTo: self.leftAnchor)
            barLeftConst.isActive = true
            barWidthConst = bar.widthAnchor.constraint(equalToConstant: 0)
            barWidthConst.isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let button = parameter.buttons.first else {
            return
        }
        
        barWidthConst.constant =  button.frame.width
    }
}
