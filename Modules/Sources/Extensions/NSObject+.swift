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

//public protocol Observablable: NSObject, Sendable {}
//public extension Observablable {
//    @discardableResult
//    func observation<T>(
//        tracking: @escaping (() -> T),
//        onChange: @escaping @Sendable ((Self, T) -> Void),
//        shouldStop: (@Sendable () -> Bool)? = nil,
//        useInitialValue: Bool = true,
//        mainThread: Bool = true
//    ) -> Self {
//        
////        func process() {
////            onChange(self, tracking())
////            
////            if let shouldStop, shouldStop() {
////                return
////            }
////            
////            self.observation(
////                tracking: tracking,
////                onChange: onChange,
////                shouldStop: shouldStop,
////                useInitialValue: useInitialValue,
////                mainThread: mainThread
////            )
////        }
//        
//        if useInitialValue {
//            onChange(self, tracking())
//        }
//        
//        _ = withObservationTracking({
//            tracking()
//        }, onChange: {
////            process()
//            onChange(self, tracking())
////            if mainThread {
////                Task { @MainActor in
////                    process()
////                }
////            } else {
////                process()
////            }
//        })
//        return self
//    }
//}

//extension NSObject: Observablable  { }
