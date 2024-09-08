// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Extensions", targets: ["Extensions"]),
        .library(name: "Utils", targets: ["Utils"]),
        .library(name: "Files", targets: ["Files"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "ChartFeature", targets: ["ChartFeature"]),
        .library(name: "CollectionViewFeature", targets: ["CollectionViewFeature"]),
        .library(name: "Components", targets: ["Components"]),
        .library(name: "HeroFeature", targets: ["HeroFeature"]),
        .library(name: "SampleAffineFeature", targets: ["SampleAffineFeature"]),
        .library(name: "SampleFeature", targets: ["SampleFeature"]),
        .library(name: "SampleTextViewFeature", targets: ["SampleTextViewFeature"]),
        .library(name: "ScrollNavigationBarFeature", targets: ["ScrollNavigationBarFeature"]),
        .library(name: "SwiftUIHostingFeature", targets: ["SwiftUIHostingFeature"]),
        .library(name: "TabNavigationFeature", targets: ["TabNavigationFeature"]),
        .library(name: "ZoomImageFeature", targets: ["ZoomImageFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sakiyamaK/DeclarativeUIKit", from: "3.2.0"),
        .package(url: "https://github.com/sakiyamaK/ObservableUIKit", from: "0.0.3"),
        .package(url: "https://github.com/sakiyamaK/UIKitConfiguration", from: "0.0.2"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.6.2"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager", from: "7.0.1"),
        .package(url: "https://github.com/mac-cain13/R.swift", from: "7.5.0"),
        .package(url: "https://github.com/HeroTransitions/Hero", from: "1.6.2"),
        .package(url: "https://github.com/danielgindi/Charts", from: "4.1.0"),
        .package(url: "https://github.com/sakiyamaK/ModernCollectionView", from: "0.0.7"),
        .package(url: "https://github.com/eddiekaiger/SwiftyAttributes", from: "5.3.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxOptional", from: "5.0.5"),
        .package(url: "https://github.com/RxSwiftCommunity/NSObject-Rx", from: "5.2.2"),
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                "Extensions",
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit")
            ]
        ),
        .target(
            name: "Extensions"
        ),
        .target(
            name: "Files",
            dependencies: [
                .product(name: "RswiftLibrary", package: "R.swift"),
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
            ]
        ),
        .target(
            name: "Utils"
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "Files",
                "Components",
                "Extensions",
                "Utils"
            ] + [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ] + [
                "HeroFeature",
                "SampleTextViewFeature",
                "ScrollNavigationBarFeature",
                "ZoomImageFeature",
                "ChartFeature",
                "CollectionViewFeature",
                "SampleAffineFeature",
                "SampleFeature",
                "TabNavigationFeature",
                "SwiftUIHostingFeature",
                "ComposeForiOSNative",
            ]
        ),
        .target(
            name: "ChartFeature",
            dependencies: [
                    .product(name: "Charts", package: "Charts"),
                ] + [
                    .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                    .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                    .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                    .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
                ]
        ),
        .target(
            name: "CollectionViewFeature",
            dependencies: [
                .product(name: "ModernCollectionView", package: "ModernCollectionView"),
                .product(name: "Hero", package: "Hero"),
                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),
                .product(name: "Kingfisher", package: "Kingfisher"),
            ] + [
                "Components",
                "Extensions",
                "Files",
                "Utils"
            ] + [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ]
        ),
        .target(
            name: "ComposeForiOSNative",
            dependencies: [
                "Extensions"
            ] + [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ]
        ),
        .target(
            name: "HeroFeature",
            dependencies: [
                .product(name: "Hero", package: "Hero"),
            ] + [
                "Extensions",
            ] + [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ]
        ),
        .target(
            name: "SampleAffineFeature",
            dependencies: [
                "Components",
                "Extensions",
                "Files",
            ] + [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
            ],
            resources: [
                .copy("C.xcassets"),
            ]
        ),
        .target(
            name: "SampleFeature",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxOptional", package: "RxOptional"),
                .product(name: "NSObject-Rx", package: "NSObject-Rx"),
                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),
            ] + [
                "Components",
                "Extensions",
                "Files"
            ] + [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ]
        ),
        .target(
            name: "SampleTextViewFeature",
            dependencies: [
                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),
            ] + [
                "Components",
                "Extensions",
            ] + [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ]
        ),
        .target(
            name: "ScrollNavigationBarFeature",
            dependencies: [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ]
        ),
        .target(
            name: "SwiftUIHostingFeature",
            dependencies: [
                "Components",
                "Extensions",
            ]
        ),
        .target(
            name: "TabNavigationFeature",
            dependencies: [
                "Components",
                "Extensions",
            ] + [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ]
        ),
        .target(
            name: "ZoomImageFeature",
            dependencies: [
                "Components",
                "Extensions",
                "Files",
            ] + [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ]
        ),
    ]
)