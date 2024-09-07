// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreLibraries",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CoreLibraries",
            targets: ["CoreLibraries"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sakiyamaK/DeclarativeUIKit", from: "3.2.0"),
        .package(url: "https://github.com/sakiyamaK/ObservableUIKit", from: "0.0.3"),
        .package(url: "https://github.com/sakiyamaK/UIKitConfiguration", from: "0.0.2"),
        .package(url: "https://github.com/sakiyamaK/ModernCollectionView", from: "0.0.7"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxOptional", from: "5.0.5"),
        .package(url: "https://github.com/RxSwiftCommunity/NSObject-Rx", from: "5.2.2"),
//        .package(url: "https://github.com/johnno1962/InjectionNext", from: "1.2.2"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.6.2"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager", from: "7.0.1"),
        .package(url: "https://github.com/HeroTransitions/Hero", from: "1.6.2"),
        .package(url: "https://github.com/eddiekaiger/SwiftyAttributes", from: "5.3.0"),
    ],
    targets: [
        .target(
            name: "CoreLibraries",
            dependencies: [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "ModernCollectionView", package: "ModernCollectionView"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxOptional", package: "RxOptional"),
                .product(name: "NSObject-Rx", package: "NSObject-Rx"),
//                .product(name: "InjectionNext", package: "InjectionNext"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
                .product(name: "Hero", package: "Hero"),
                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),
            ]
        ),
    ]
)
