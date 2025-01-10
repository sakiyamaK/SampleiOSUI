//
//  UIEdgeInsets+.swift
//
//
//  Created by sakiyamaK on 2024/08/06.
//

import UIKit

public extension UIEdgeInsets {
    struct SaveEdgeInsets {
        private enum Edge: Hashable {
            case top(CGFloat = 0), left(CGFloat = 0), bottom(CGFloat = 0), right(CGFloat = 0)
        }
        private var insets: UIEdgeInsets
        private var savedEdges: Set<Edge> = []

        init(insets: UIEdgeInsets) {
            self.insets = insets
        }

        private init(insets: UIEdgeInsets, savedEdges: Set<Edge>) {
            self.insets = insets
            self.savedEdges = savedEdges
        }

        public func top(addValue: CGFloat = 0) -> SaveEdgeInsets {
            var newSavedEdges = savedEdges
            newSavedEdges.insert(.top(addValue))
            return SaveEdgeInsets(insets: self.insets, savedEdges: newSavedEdges)
        }
        public var top: SaveEdgeInsets {
            top()
        }

        public func left(addValue: CGFloat = 0) -> SaveEdgeInsets {
            var newSavedEdges = savedEdges
            newSavedEdges.insert(.left(addValue))
            return SaveEdgeInsets(insets: self.insets, savedEdges: newSavedEdges)
        }
        public var left: SaveEdgeInsets {
            left()
        }

        public func bottom(addValue: CGFloat = 0) -> SaveEdgeInsets {
            var newSavedEdges = savedEdges
            newSavedEdges.insert(.bottom(addValue))
            return SaveEdgeInsets(insets: self.insets, savedEdges: newSavedEdges)
        }
        public var bottom: SaveEdgeInsets {
            bottom()
        }

        public func right(addValue: CGFloat = 0) -> SaveEdgeInsets {
            var newSavedEdges = savedEdges
            newSavedEdges.insert(.right(addValue))
            return SaveEdgeInsets(insets: self.insets, savedEdges: newSavedEdges)
        }
        public var right: SaveEdgeInsets {
            right()
        }

        public func vertical(addValue: CGFloat = 0) -> SaveEdgeInsets {
            var newSavedEdges = savedEdges
            newSavedEdges.insert(.top(addValue))
            newSavedEdges.insert(.bottom(addValue))
            return SaveEdgeInsets(insets: self.insets, savedEdges: newSavedEdges)
        }
        public var vertical: SaveEdgeInsets {
            vertical()
        }

        public func horizontal(addValue: CGFloat = 0) -> SaveEdgeInsets {
            var newSavedEdges = savedEdges
            newSavedEdges.insert(.left(addValue))
            newSavedEdges.insert(.right(addValue))
            return SaveEdgeInsets(insets: self.insets, savedEdges: newSavedEdges)
        }
        public var horizontal: SaveEdgeInsets {
            horizontal()
        }

        public var fixed: UIEdgeInsets {
            var newInsets: UIEdgeInsets = .zero
            for savedEdge in savedEdges {
                switch savedEdge {
                case .top(let value):
                    newInsets.top = insets.top + value
                case .left(let value):
                    newInsets.left = insets.left + value
                case .bottom(let value):
                    newInsets.bottom = insets.bottom + value
                case .right(let value):
                    newInsets.right = insets.right + value
                }
            }
            return newInsets
        }
    }

    var select: SaveEdgeInsets {
        SaveEdgeInsets(insets: self)
    }
}

public extension UIEdgeInsets {
    var directionalEdgeInsets: NSDirectionalEdgeInsets {
        .init(top: self.top, leading: self.left, bottom: self.bottom, trailing: self.right)
    }
}
