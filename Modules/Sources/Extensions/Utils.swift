//
//  Util.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2023/02/15.
//

import UIKit

// デバッグビルドでしか出ない
public func DLog(_ obj: Any? = nil, file: String = #file, function: String = #function, line: Int = #line) {
    var filename: NSString = file as NSString
    filename = filename.lastPathComponent as NSString
    let text: String
    if let obj = obj {
        text = "[File:\(filename) Func:\(function) Line:\(line)] : \(obj)"
    } else {
        text = "[File:\(filename) Func:\(function) Line:\(line)]"
    }
    print(text)
}
