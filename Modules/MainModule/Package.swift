// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MainModule",
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
        .package(url: "https://github.com/sakiyamaK/DeclarativeUIKit", branch: "feature/UIPopoverPresentationController"),
        .package(url: "https://github.com/sakiyamaK/ObservableUIKit", from: "0.0.3"),
        .package(url: "https://github.com/danielgindi/Charts", from: "4.1.0"),
        .package(url: "https://github.com/johnno1962/HotReloading", branch: "main"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxOptional", from: "5.0.5"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.6.2"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager", from: "6.5.0"),
        .package(url: "https://github.com/HeroTransitions/Hero", from: "1.6.2"),
        .package(url: "https://github.com/eddiekaiger/SwiftyAttributes.git", from: "5.3.0"),
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
                .target(name: "StackTableFeature"),
                .target(name: "SampleAffineFeature"),
                .target(name: "CollectionViewFeature"),
                .target(name: "SampleTextViewFeature"),
                .target(name: "ScrollNavigationBarFeature"),
                .target(name: "TabNavigationFeature"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ]
        ),
        .target(
            name: "Extensions",
            dependencies: [
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
                .target(name: "Extensions"),
                .target(name: "Components"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxOptional", package: "RxOptional"),
                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),                
            ]
        ),
        .target(
            name: "SampleTextViewFeature",
            dependencies: [
                .target(name: "Extensions"),
                .target(name: "Components"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
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
            name: "StackTableFeature",
            dependencies: [
                .target(name: "Extensions"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
            ]
        ),
        .target(
            name: "SampleAffineFeature",
            dependencies: [
                .target(name: "Extensions"),
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "HotReloading", package: "HotReloading"),
            ]
        ),
        .target(
            name: "CollectionViewFeature",
            dependencies: [
                .target(name: "Extensions"),
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
        )
        //        .testTarget(
        //            name: "AppTests",
        //            dependencies: ["AppFeature"]),
    ]
)
