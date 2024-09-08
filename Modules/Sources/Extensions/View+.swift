//
//  View+.swift
//  
//
//  Created by sakiyamaK on 2024/09/07.
//

import SwiftUI

public extension View {
    var viewController: UIHostingController<Self> {
        UIHostingController(rootView: self)
    }
}
