////
////  EnableLinkOnlyTextView.swift
////  
////
////  Created by sakiyamaK on 2023/04/08.
////
//
//import UIKit
//
//// リンクテキストしかタップできないUITextView
//// https://qiita.com/taka4/items/45736821bd20b10193a1
//public final class EnableLinkOnlyTextView: UITextView {
//    // NOTE: リンクテキストしかタップおよび選択できないようにする
//    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        guard let position = closestPosition(to: point),
//              let range = tokenizer.rangeEnclosingPosition(position, with: .character, inDirection: UITextDirection(rawValue: UITextLayoutDirection.left.rawValue)) else {
//            return false
//        }
//        let startIndex = offset(from: beginningOfDocument, to: range.start)
//        let attributeName = NSAttributedString.Key.link
//        let attributes = textStorage.attributes(at: startIndex, effectiveRange: nil)
//
//        return attributes[attributeName] != nil
//    }
//
//    // NOTE: テキストが選択された場合に、コピーなどのメニューを出さないようにする
//    public override func becomeFirstResponder() -> Bool {
//        return false
//    }
//}
