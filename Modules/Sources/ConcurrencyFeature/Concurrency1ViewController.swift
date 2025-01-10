import UIKit
import DeclarativeUIKit
import Extensions
import Components
import Files

struct StructCounter {
    var value: Int = 0
    mutating func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        self.value = self.value + 1
    }
    mutating func reset() {
        value = 0
    }
}

final class ClassCounter {
    var value: Int = 0
    func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        self.value = self.value + 1
    }
    func reset() {
        value = 0
    }
}

actor ActorCounter {
    var value: Int = 0
    func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        self.value = self.value + 1
    }
    func reset() {
        value = 0
    }
}

@MainActor
class MainActorClassCounter {
    var value: Int = 0
    func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        self.value = self.value + 1
    }
    func reset() {
        value = 0
    }
}

@MainActor
struct MainActorStructCounter {
    var value: Int = 0
    mutating func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        self.value = self.value + 1
    }
    mutating func reset() {
        value = 0
    }
}

/*
 そもそもSwift6だと可変な値をもつ参照型はSendableに準拠させてビルドができない
 */
//final class SendableClassCounter: Sendable {
//    var value: Int = 0
//    func increment() {
//        self.value = self.value + 1
//    }
//    func reset() {
//        value = 0
//    }
//}

struct SendableStructCounter: Sendable {
    var value: Int = 0
    mutating func increment() async {
        try? await Task.sleep(for: .milliseconds(1000))
        self.value = self.value + 1
    }
    mutating func reset() {
        value = 0
    }
}

public class Concurrency1ViewController: UIViewController {

    func structButton(label: UILabel) -> UIStackView {
        var counter = StructCounter()

        return UIStackView.vertical {
            UILabel("struct")
            
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

    func classButton(label: UILabel) -> UIStackView {
        
        let counter = ClassCounter()

        return UIStackView.vertical {
            UILabel("class")
            
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    Task {
                        print("tap")

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

    func actorButton(label: UILabel) -> UIStackView {
        
        let counter = ActorCounter()

        return UIStackView.vertical {
            UILabel("actor")
            
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    Task {
                        print("tap")

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
    
    func mainActorClassButton(label: UILabel) -> UIStackView {
        
        let counter = MainActorClassCounter()

        return UIStackView.vertical {
            UILabel("main actor class")
                        
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    Task {
                        print("tap")

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

    func mainActorStructButton(label: UILabel) -> UIStackView {
        
        var counter = MainActorStructCounter()

        return UIStackView.vertical {
            UILabel("main actor struct")
                        
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    Task {
                        print("tap")

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

    func sendableStructButton(label: UILabel) -> UIStackView {
        var counter = SendableStructCounter()

        return UIStackView.vertical {
            UILabel("sendable struct")
            
            UIButton(
                configuration: .bordered(),
                primaryAction: .init(title: "100増やして", handler: {_ in
                    Task {
                        print("tap")

                        label.text = nil
                        
                        counter.reset()

                        await withTaskGroup(of: Void.self) { group in
                            
                            for _ in 1...100 {
                                // 100個並列で100のfor文を動かす
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
                UILabel(assign: &self.label)
                    .textAlignment(.center)
                    .padding()
                    .border(color: .black, width: 1)
                    .minHeight(100)
                    .padding()
                
                UIScrollView.vertical {
                    UIStackView.vertical {
                                                
                        structButton(label: label)
                            .spacing(10)
                        
                        classButton(label: label)
                            .spacing(10)
                        
                        actorButton(label: label)
                            .spacing(10)
                        
                        mainActorClassButton(label: label)
                            .spacing(10)

                        mainActorStructButton(label: label)
                            .spacing(10)

                        sendableStructButton(label: label)
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
    Concurrency1ViewController()
}
