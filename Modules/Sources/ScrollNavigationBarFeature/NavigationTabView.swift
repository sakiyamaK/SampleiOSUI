//
//  NavigationTabView.swift
//
//
//  Created by sakiyamaK on 2024/04/08.
//

import UIKit
import Extensions

public class NavigationTabView: UIView, ScrollNavigationTabBarPageTabViewProtocol {
    
    public weak var navigationTabBarScrollView: UIScrollView!
    public var tap: ((Int) -> Void)?
    
    struct Parameter {
        let buttons: [UIView]
        let bar: UIView
    }
    
    private var barWidthConsts: [NSLayoutConstraint] = []
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
                }.assign(to: &self.navigationTabBarScrollView)
            }
        
        if !parameter.buttons.isEmpty {
            let bar = parameter.bar
            bar.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(bar)
            bar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            barLeftConst = bar.leftAnchor.constraint(equalTo: self.leftAnchor)
            barLeftConst.isActive = true
            barWidthConsts = parameter.buttons.compactMap {
                bar.widthAnchor.constraint(equalTo: $0.widthAnchor)
            }
            barWidthConsts.first?.isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func selectTab(index: Int) {

        moveBar(index: index)
        updateBarWidth(index: index)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
        
    }
    
    private func moveBar(index: Int) {
        barLeftConst.constant = if
            index <= 0 || parameter.buttons.count <= index {
            0
        } else {
            parameter.buttons.compactMap({
                $0.frame.maxX
            })[0...(index-1)].reduce(0, +)
        }
    }
    
    private func updateBarWidth(index: Int) {
        
        barWidthConsts.forEach {
            $0.isActive = false
        }
        barWidthConsts[safe: index]?.isActive = true
    }
    
}
