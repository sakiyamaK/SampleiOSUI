//
//  File.swift
//  
//
//  Created by sakiyamaK on 2023/03/23.
//

import Foundation

public extension NSObject {
    var className: String {
        String(describing: type(of: self))
    }
    
    static var className: String {
        String(describing: self)
    }
}
