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
