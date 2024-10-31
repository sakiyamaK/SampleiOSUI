//
//  UIView+.swift
//  
//
//  Created by sakiyamaK on 2024/09/16.
//

import UIKit

extension UIView {
    typealias ArroundConstraintConstants = (top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat)
    
    func apply(constraints: [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
        
    func apply(constraint: NSLayoutConstraint) {
        apply(constraints: [constraint])
    }

    func applyArroundConstraint(equalTo layoutGuide: UILayoutGuide, constants: ArroundConstraintConstants = (0, 0, 0, 0)) {
        self.apply(constraints: [
            self.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: constants.top),
            self.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: constants.leading),
            layoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constants.bottom),
            layoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constants.trailing)
        ])
    }
    
    func applyArroundConstraint(equalTo view: UIView, constants: ArroundConstraintConstants = (0, 0, 0, 0)) {
        self.apply(constraints: [
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: constants.top),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constants.leading),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constants.bottom),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constants.trailing)
        ])
    }
}

// MARK: - Observablable
public protocol Observablable: NSObject {}
public extension Observablable {
    @discardableResult
    func observation<T>(
        tracking: @escaping (() -> T),
        onChange: @escaping ((Self, T) -> Void),
        shouldStop: (() -> Bool)? = nil,
        useInitialValue: Bool = true,
        mainThread: Bool = true
    ) -> Self {
        
        @Sendable func process() {
            onChange(self, tracking())
            
            if let shouldStop, shouldStop() {
                return
            }
            
            self.observation(
                tracking: tracking,
                onChange: onChange,
                shouldStop: shouldStop,
                useInitialValue: useInitialValue,
                mainThread: mainThread
            )
        }
        
        if useInitialValue {
            onChange(self, tracking())
        }
        
        _ = withObservationTracking({
            tracking()
        }, onChange: {
            if mainThread {
                Task { @MainActor in
                    process()
                }
            } else {
                process()
            }
        })
        return self
    }
}

extension NSObject: Observablable { }

