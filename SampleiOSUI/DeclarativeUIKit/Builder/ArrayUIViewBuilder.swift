//
//  ArrayUIViewBuilder.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2021/12/22.
//

import UIKit.UIView

@resultBuilder
struct ArrayUIViewBuilder {
    static func buildBlock(_ components: UIView...) -> [UIView] {
        components
    }
    //    static func buildBlock(_ components1: UIView..., components2: UIView...) -> [UIView] {
    //        components1 + components2
    //    }
    //
    //    static func buildOptional(_ components: UIView?...) -> [UIView?] {
    //        components
    //    }

    //    static func buildBlock(_ component: [UIView]) -> [UIView] { component }
    //    static func buildEither(first component: [UIView]) -> [UIView] { component }
    //    static func buildEither(second component: [UIView]) -> [UIView] { component }
}
