// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MainModule",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppLibrary",
            targets: [
                "AppFeature"
            ]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/sakiyamaK/DeclarativeUIKit", branch: "2.0.2"),
        .package(url: "https://github.com/sakiyamaK/ObservableUIKit", from: "0.0.3"),
        .package(url: "https://github.com/sakiyamaK/UIKitConfiguration", from: "0.0.2"),
        .package(url: "https://github.com/danielgindi/Charts", from: "4.1.0"),
        .package(url: "https://github.com/johnno1962/HotReloading", branch: "main"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxOptional", from: "5.0.5"),
        .package(url: "https://github.com/RxSwiftCommunity/NSObject-Rx", from: "5.2.2"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.6.2"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager", from: "7.0.1"),
        .package(url: "https://github.com/HeroTransitions/Hero", from: "1.6.2"),
        .package(url: "https://github.com/eddiekaiger/SwiftyAttributes.git", from: "5.3.0"),
        .package(url: "https://github.com/mac-cain13/R.swift.git", from: "7.4.0"),
        .package(url: "https://github.com/rechsteiner/Parchment", from: "3.2.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppFeature",
            dependencies: [
                .target(name: "Extensions"),
                .target(name: "Components"),
                .target(name: "ChartFeature"),
                .target(name: "SwiftUIHostingFeature"),
                .target(name: "SampleTableFeature"),
                .target(name: "SampleFeature"),
                .target(name: "ZoomImageFeature"),
                .target(name: "SampleAffineFeature"),
                .target(name: "CollectionViewFeature"),
                .target(name: "SampleTextViewFeature"),
                .target(name: "ScrollNavigationBarFeature"),
                .target(name: "TabNavigationFeature"),
                .target(name: "ComposeForiOSNative"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
                .product(name: "Parchment", package: "Parchment"),
            ]
        ),
        .target(
            name: "Extensions",
            dependencies: [
                .product(name: "Parchment", package: "Parchment"),
            ]
        ),
        .target(
            name: "Components",
            dependencies: [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading")
            ]
        ),
        
            .target(
                name: "ChartFeature",
                dependencies: [
                    .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                    .product(name: "HotReloading", package: "HotReloading"),
                    .product(name: "Charts", package: "Charts"),
                ]
            ),
        .target(
            name: "SwiftUIHostingFeature",
            dependencies: [
                .target(name: "Extensions"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading")
            ]
        ),
        .target(
            name: "SampleTableFeature",
            dependencies: [
                .target(name: "Extensions"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
            ]
        ),
        .target(
            name: "SampleFeature",
            dependencies: [
                .target(name: "ResourceFeature"),
                .target(name: "Extensions"),
                .target(name: "Components"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "Parchment", package: "Parchment"),
                .product(name: "HotReloading", package: "HotReloading"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxOptional", package: "RxOptional"),
                .product(name: "NSObject-Rx", package: "NSObject-Rx"),
                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),
            ]
        ),
        .target(
            name: "SampleAffineFeature",
            dependencies: [
                .target(name: "Extensions"),
                .target(name: "ResourceFeature"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
            ]
        ),
        .target(
            name: "ResourceFeature",
            dependencies: [.product(name: "RswiftLibrary", package: "R.swift")],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift")]
        ),
        .target(
            name: "SampleTextViewFeature",
            dependencies: [
                .target(name: "Extensions"),
                .target(name: "Components"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
//                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
            ]
        ),
        .target(
            name: "ScrollNavigationBarFeature",
            dependencies: [
                .target(name: "Extensions"),
                .target(name: "Components"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
            ]
        ),
        .target(
            name: "ZoomImageFeature",
            dependencies: [
            ]
        ),
        .target(
            name: "CollectionViewFeature",
            dependencies: [
                .target(name: "Extensions"),
                .target(name: "ResourceFeature"),                
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Hero", package: "Hero"),
            ]
        ),
        .target(
            name: "TabNavigationFeature",
            dependencies: [
                .target(name: "Extensions"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
            ]
        ),
        .target(
            name: "ComposeForiOSNative",
            dependencies: [
                .target(name: "Extensions"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
            ]
        ),
        //        .testTarget(
        //            name: "AppTests",
        //            dependencies: ["AppFeature"]),
    ]
)
