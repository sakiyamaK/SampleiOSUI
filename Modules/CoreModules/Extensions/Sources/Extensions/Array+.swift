//
//  Array+.swift
//  SampleCompositonalLayout
//
//  Created by sakiyamaK on 2021/06/27.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

public extension Array {
    subscript(safe range: ClosedRange<Int>) -> Self {
        guard let first = range.first, let last = range.last,
              count > first
        else {
            return self
        }
        if count <= first + last {
            let nRange = first ... (count - 1)
            return self[nRange].map { $0 }
        }
        return self[range].map { $0 }
    }

    subscript(safe range: Range<Int>) -> Self {
        guard let first = range.first, let last = range.last,
              count > first
        else {
            return self
        }
        if count <= last {
            let nRange = first ... (count - 1)
            return self[nRange].map { $0 }
        }
        return self[range].map { $0 }
    }
}

import UIKit
#Preview {
    {
        let vc = UIViewController()
        let label = UILabel(frame: .init(origin: .zero, size: .init(width: 100, height: 100)))
        label.text = "おっす"
        label.textColor = .black
        label.textAlignment = .center
        vc.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
        ])
        return vc
    }()
}
