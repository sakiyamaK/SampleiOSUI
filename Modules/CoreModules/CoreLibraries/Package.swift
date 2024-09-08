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
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.6.2"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager", from: "7.0.1"),
    ],
    targets: [
        .target(
            name: "CoreLibraries",
            dependencies: [
                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
                .product(name: "UIKitConfiguration", package: "UIKitConfiguration"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ]
        ),
    ]
)
