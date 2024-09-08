import Foundation

// メモリーリークチェッククラス
@MainActor
public class LeakChecker {
    public static let shared: LeakChecker = .init()
    private init() {}
    
    private class WeakClassWrapper {
        weak var object: AnyObject?
        init(object: AnyObject?) {
            self.object = object
        }
    }
    
    private var weakClassInstances: [WeakClassWrapper] = []
}
public extension LeakChecker {
    func append(instance: AnyObject) {
        weakClassInstances.append(WeakClassWrapper(object: instance))
    }
    
    func check() {
        let newWeakClassInstances = weakClassInstances.filter({ $0.object != nil })
        if newWeakClassInstances.isEmpty {
            print("リークなし")
        } else {
            print(newWeakClassInstances.count.description + "個のインスタンスがリークしてます")
        }
        
        weakClassInstances = newWeakClassInstances
    }
}
