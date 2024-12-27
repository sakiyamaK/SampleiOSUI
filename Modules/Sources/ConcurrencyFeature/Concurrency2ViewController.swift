import UIKit
import DeclarativeUIKit
import Extensions
import Components
import Files

protocol ProtocolCounter {
    var value: Int { get }
    // structにも準拠させるのでmutating
    mutating func reset()
    mutating func increment() async
}

protocol ProtocolSendableCounter: Sendable {
    var value: Int { get async }
    // structにも準拠させるのでmutating
    mutating func reset() async
    mutating func increment() async
}

final class ProtocolCounterClass: ProtocolCounter {
    var value: Int = 0
    func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        self.value = self.value + 1
    }
    func reset() {
        value = 0
    }
}

// Swift6だとビルドエラーになる
// Sendableに準拠させるならデータ競合が起きるような書き方ができない
//final class ProtocolSendableClassCounter: ProtocolSendableCounter {
//    var _value: Int = 0
//    
//    var value: Int {
//        get async {
//            _value
//        }
//    }
//    
//    func reset() async {
//        _value = 0
//    }
//    
//    func increment() async {
//        _value = _value + 1
//    }
//}

// @preconcurrencyはactorだけど危険なprotocolに準拠するよという意味
actor ProtocolCounterActor: @preconcurrency ProtocolCounter {
    var value: Int = 0
    func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        value = value + 1
    }
    func reset() {
        value = 0
    }
 }

// structは値型で安全にコピーできるので準拠できる
// ただし値型そのものをmutatingに更新するとデータ競合は起きるから注意
struct ProtocolSendableCounterStruct: ProtocolSendableCounter {
    private var _value: Int = 0
    var value: Int {
        get async {
            _value
        }
    }
    mutating func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        _value = _value + 1
    }
    mutating func reset() async {
        _value = 0
    }
}

// SendableなProtocolは安全だからactorに準拠できる
actor ProtocolSendableCounterActor:  ProtocolSendableCounter {
    private var _value: Int = 0
    var value: Int {
        get async {
            _value
        }
    }
    func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        _value = _value + 1
    }
    func reset() async {
        _value = 0
    }
}

// 内部でデータ競合のあるクラスをもつactor
actor ClassCounterInActor {
    private var counter: ClassCounter = .init()
    var value: Int {
        counter.value
    }
    func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        await counter.increment()
    }
    func reset() {
        counter.reset()
    }
}

// 内部でデータ競合のあるクラスをもつMainActor
@MainActor
class ClassCounterInMainActor {
    private var counter: ClassCounter = .init()
    var value: Int {
        counter.value
    }
    func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        await self.counter.increment()
    }
    func reset() {
        counter.reset()
    }
}

public class Concurrency2ViewController: UIViewController {
    
    func protocolCounterClass(label: UILabel) -> UIStackView {
        
        let counter = ProtocolCounterClass()
        
        return UIStackView.vertical {
            UILabel("ProtocolCounterClass")
            
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    
                    print("tap")
                    
                    Task {
                        label.text = nil

                        counter.reset()
                        
                        await withTaskGroup(of: Void.self) { group in

                            for _ in 1...100 {
                                group.addTask {
                                    await counter.increment()
                                }
                            }
                        }
                        
                        print("finish")

                        label.text = counter.value.description
                    }
                })
            )
        }
    }
    
    func protocolCounterActorButton(label: UILabel) -> UIStackView {
        
        let counter = ProtocolCounterActor()
        
        return UIStackView.vertical {
            UILabel("ProtocolCounterActor")
            
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    
                    print("tap")
                    
                    Task {
                        label.text = nil
                        
                        await counter.reset()
                        
                        await withTaskGroup(of: Void.self) { group in

                            for _ in 1...100 {
                                group.addTask {
                                    await counter.increment()
                                }
                            }
                        }
                        
                        print("finish")

                        label.text = await counter.value.description
                    }
                })
            )
        }
    }

    func protocolSendableCounterActorButton(label: UILabel) -> UIStackView {
        
        let counter = ProtocolSendableCounterActor()
        
        return UIStackView.vertical {
            UILabel("ProtocolSendableCounterActor")
            
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    
                    print("tap")
                    
                    Task {
                        label.text = nil
                        await counter.reset()
                        
                        await withTaskGroup(of: Void.self) { group in

                            for _ in 1...100 {
                                group.addTask {
                                    await counter.increment()
                                }
                            }
                        }
                        
                        print("finish")

                        label.text = await counter.value.description
                    }
                })
            )
        }
    }
   
    func protocolSendableCounterStructButton(label: UILabel) -> UIStackView {
        
        var counter = ProtocolSendableCounterStruct()
        
        return UIStackView.vertical {
            UILabel("ProtocolSendableCounterStruct")
            
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    
                    print("tap")
                    
                    Task {
                        label.text = nil
                        await counter.reset()
                        
                        await withTaskGroup(of: Void.self) { group in

                            for _ in 1...100 {
                                group.addTask {
                                    await counter.increment()
                                }
                            }
                        }
                        
                        print("finish")

                        label.text = await counter.value.description
                    }
                })
            )
        }
    }

    func classCounterInActorButton(label: UILabel) -> UIStackView {
        
        let counter = ClassCounterInActor()
        
        return UIStackView.vertical {
            UILabel("ClassCounterInActor")
            
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    print("tap")
                    
                    Task {
                        label.text = nil
                        await counter.reset()
                        
                        await withTaskGroup(of: Void.self) { group in

                            for _ in 1...100 {
                                group.addTask {
                                    await counter.increment()
                                }
                            }
                        }
                        
                        print("finish")

                        label.text = await counter.value.description
                    }
                })
            )
        }
    }
    
    func classCounterInMainActorButton(label: UILabel) -> UIStackView {
        
        let counter = ClassCounterInMainActor()
        
        return UIStackView.vertical {
            UILabel("ClassCounterInMainActor")
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    print("tap")
                    
                    Task {
                        label.text = nil
                        counter.reset()
                        
                        await withTaskGroup(of: Void.self) { group in

                            for _ in 1...100 {
                                group.addTask {
                                    await counter.increment()
                                }
                            }
                        }
                        
                        print("finish")

                        label.text = counter.value.description
                    }
                })
            )
        }
    }
    
    private weak var label: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyView {
            $0.backgroundColor(.white)
        }.declarative {
            UIStackView.vertical {
                UILabel(assign: &label)
                    .numberOfLines(0)
                    .textAlignment(.center)
                    .padding()
                    .border(color: .gray, width: 1)
                    .minHeight(100)
                    .padding()

                UIScrollView.vertical {
                    UIStackView.vertical {
                        protocolCounterClass(label: label)
                            .spacing(10)
                        
                        protocolCounterActorButton(label: label)
                            .spacing(10)
                        
                        protocolSendableCounterActorButton(label: label)
                            .spacing(10)
                        
                        protocolSendableCounterStructButton(label: label)
                        
                        classCounterInActorButton(label: label)
                            .spacing(10)
                        
                        classCounterInMainActorButton(label: label)
                            .spacing(10)
                    }
                    .spacing(40)
                    .centerX()
                }
            }
        }
    }
}


#Preview {
    Concurrency2ViewController()
}
