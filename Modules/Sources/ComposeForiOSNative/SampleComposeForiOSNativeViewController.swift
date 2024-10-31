//
//  SampleComposeForiOSNativeViewController.swift
//
//
//  Created by sakiyamaK on 2023/11/16.
//

import UIKit
import Extensions
import DeclarativeUIKit
import ObservableUIKit


@resultBuilder
public enum ArrayComposeBuilder {
    public typealias Component = [any Expression]
    public typealias Expression = ComposeForiOSNative
    
    public static func buildExpression(_ element: any Expression) -> Component {
        return [element]
    }
    
    public static func buildExpression(_ component: Component) -> Component {
        return component
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else { return [] }
        return component
    }
    
    public static func buildEither(first component: Component) -> Component {
        return component
    }
    
    public static func buildEither(second component: Component) -> Component {
        return component
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        return Array(components.joined())
    }
    
    public static func buildBlock(_ components: Component...) -> Component {
        return Array(components.joined())
    }
    
    public static func buildBlock() -> Component {
        return []
    }
}

@MainActor
public protocol ComposeForiOSNative {
    associatedtype View: UIView
    var view: View { get }
    var modifier: Modifier? { get }
}

public extension UIViewController {
    func setContent(_ compose: () -> any ComposeForiOSNative) {
        view.backgroundColor = .white
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        let composed = compose()
        let view = composed.view
        if let modifier = composed.modifier {
//            switch modifier {
//            case .fillMaxSize:
//                self.view.edgesConstraints(
//                    view,
//                    safeAreas: .init(all: true),
//                    priorities: .init(top: .init(2), leading: .init(1000), bottom: .init(1), trailing: .init(1000))
//                )
//            }
        } else {
            self.view.edgesConstraints(
                view,
                safeAreas: .init(all: true),
                priorities: .init(
                    top: .init(1000),
                    leading: .init(1000),
                    bottom: .init(1000),
                    trailing: .init(1000)
                )
            )
        }
    }
}

public protocol Modifier {
    func then(_ other: Modifier) -> any Modifier
}
public extension Modifier {
    func then(_ other: Modifier) -> any Modifier {
        other
    }
}
public extension Modifier {
    func height(_ height: Float) -> any Modifier {
        self.then(
            SizeModifier(
                minHeight: height,
                maxHeight: height,
                enforceIncoming: true
            )
        )
    }
    
    func width(_ width: Float) -> any Modifier {
        self.then(
            SizeModifier(
                minWidth: width,
                maxWidth: width,
                enforceIncoming: true
            )
        )
    }
    
    static func height(_ height: Float) -> any Modifier {
        SizeModifier(
            minHeight: height,
            maxHeight: height,
            enforceIncoming: true
        )
    }
    
    static func width(_ width: Float) -> any Modifier {
        SizeModifier(
            minWidth: width,
            maxWidth: width,
            enforceIncoming: true
        )
    }
}

private class SizeModifier: Modifier {
    private var minWidth: Float = .nan
    private var minHeight: Float = .nan
    private var maxWidth: Float = .nan
    private var maxHeight: Float = .nan
    private var enforceIncoming: Bool = false
    init(
        minWidth: Float = .nan,
        minHeight: Float = .nan,
        maxWidth: Float = .nan,
        maxHeight: Float = .nan,
        enforceIncoming: Bool = false) {
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.enforceIncoming = enforceIncoming
    }
}

//case fillMaxSize(point: Int = 0)


public enum Arrangement {
    case Center, SpaceEvenly
    
    var uiStackViewDistribution: UIStackView.Distribution {
        switch self {
        case .Center:
            UIStackView.Distribution.equalCentering
        case .SpaceEvenly:
            UIStackView.Distribution.fillProportionally
        }
    }
}

public enum Alignment {
    case CenterHorizontally
    var uiStackViewAlignment: UIStackView.Alignment {
        switch self {
        case .CenterHorizontally:
            UIStackView.Alignment.center
        }
    }
}

public class Text: ComposeForiOSNative {
    public typealias View = UILabel
    public var view: View = .init()
    public var modifier: Modifier?
    private init() {}
    convenience init(modifier: Modifier? = nil, _ text: String) {
        self.init()
        self.modifier = modifier
        view.text = text
    }
}

public class HelperTouchTransparencyView: UIView {
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

public class Box: ComposeForiOSNative {
    public typealias View = HelperTouchTransparencyView
    public var view: View = .init()
    public var modifier: Modifier?
    private init() {}
    convenience init(modifier: (any Modifier)? = nil) {
        self.init()
        self.modifier = modifier
    }
}


public class Column: ComposeForiOSNative {
    public typealias View = UIStackView
    public var view: View = .init()
    public var modifier: Modifier?
    public var verticalArrangement: Arrangement?
    public var horizontalAlignment: Alignment?
    private init() {}
    convenience init(
        modifier: Modifier? = nil,
        verticalArrangement: Arrangement? = nil,
        horizontalAlignment: Alignment? = nil,
        @ArrayComposeBuilder _ composes: () -> [(any ComposeForiOSNative)?]) {
            self.init()
            self.modifier = modifier
            view.axis = .vertical
            if let verticalArrangement {
                view.distribution = verticalArrangement.uiStackViewDistribution
            }
            if let horizontalAlignment {
                view.alignment = horizontalAlignment.uiStackViewAlignment
            }
            composes().compactMap({ $0?.view }).forEach {
                view.addArrangedSubview($0)
            }
        }
}

public class Row: ComposeForiOSNative {
    public typealias View = UIStackView
    public var view: View = .init()
    public var modifier: Modifier?
    private init() {}
    convenience init(
        modifier: Modifier? = nil,
        horizontalArrangement: Arrangement? = nil,
        verticalAlignment: Alignment? = nil,
        @ArrayComposeBuilder _ composes: () -> [(any ComposeForiOSNative)?]) {
            self.init()
            self.modifier = modifier
            view.axis = .vertical
            if let horizontalArrangement {
                view.distribution = horizontalArrangement.uiStackViewDistribution
            }
            if let verticalAlignment {
                view.alignment = verticalAlignment.uiStackViewAlignment
            }
            composes().compactMap({ $0?.view }).forEach {
                view.addArrangedSubview($0)
            }
        }
}


public final class SampleComposeForiOSNativeViewController: UIViewController {
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setContent {
            Column(
                verticalArrangement: Arrangement.Center,
                horizontalAlignment: Alignment.CenterHorizontally
            ) {
                Text("Compose")
                Box(modifier: SizeModifier(
                    minHeight: 10,
                    maxHeight: 10,
                    enforceIncoming: true
                ))
                Text("Compose")
            }
        }
    }
}

#Preview {
    SampleComposeForiOSNativeViewController()
}
