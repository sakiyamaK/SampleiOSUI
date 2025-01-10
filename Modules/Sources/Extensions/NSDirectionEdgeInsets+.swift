//
//  NSDirectionalEdgeInsets+.swift
//
//
//  Created by sakiyamaK on 2024/07/08.
//

import UIKit

public extension NSDirectionalEdgeInsets {
    init(all: CGFloat) {
        self.init(top: all, leading: all, bottom: all, trailing: all)
    }

    init(vertical: CGFloat) {
        self.init(top: vertical, leading: 0, bottom: vertical, trailing: 0)
    }

    init(horizontal: CGFloat) {
        self.init(top: 0, leading: horizontal, bottom: 0, trailing: horizontal)
    }

    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    init(top: CGFloat) {
        self.init(top: top, leading: 0, bottom: 0, trailing: 0)
    }

    init(left: CGFloat) {
        self.init(top: 0, leading: left, bottom: 0, trailing: 0)
    }

    init(bottom: CGFloat) {
        self.init(top: 0, leading: 0, bottom: bottom, trailing: 0)
    }

    init(right: CGFloat) {
        self.init(top: 0, leading: 0, bottom: 0, trailing: right)
    }

    var edgeInsets: UIEdgeInsets {
        .init(
            top: self.top,
            left: self.leading,
            bottom: self.bottom,
            right: self.trailing
        )
    }
}
