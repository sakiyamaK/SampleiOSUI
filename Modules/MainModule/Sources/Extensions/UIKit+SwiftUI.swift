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

public extension UIView {
    private struct Preview: UIViewRepresentable {
        let view: UIView

        func makeUIView(context _: Context) -> UIView { view }

        func updateUIView(_: UIView, context _: Context) {}
    }

    func toPreview() -> some View {
        Preview(view: self)
    }
}

public extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context _: Context) -> UIViewController { viewController }

        func updateUIViewController(_: UIViewController, context _: Context) {}
    }

    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
