//
//  SwiftUI+.swift
//  SampleCompositonalLayout
//
//  Created by sakiyamaK on 2021/04/08.
//

import SwiftUI

public enum PreviewDeviceType: String {
    case se1 = "iPhone SE (1st generation)"
    case eight = "iPhone 8"
    case x = "iPhone X"
    case se2 = "iPhone SE (2nd generation)"
    case eleven = "iPhone 11"
    case elevenProMax = "iPhone 11 Pro Max"

    var device: PreviewDevice { PreviewDevice(rawValue: rawValue) }

    var displayName: String {
        switch self {
        case .se1: return "SE1"
        case .eight: return "8"
        case .x: return "X"
        case .se2: return "SE2"
        case .eleven: return "11"
        case .elevenProMax: return "11 Pro Max"
        }
    }
}

public extension UIViewController {
    func addHostingController(rootView: some View, containerView: UIView) {
        self.addContainer(
            viewController: UIHostingController(
                    rootView: rootView
            ),
            containerView: containerView
        )
    }
}
