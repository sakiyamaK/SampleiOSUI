// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Extensions",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Extensions",
            targets: ["Extensions"]),
    ],
    targets: [
        .target(
            name: "Extensions"),
//        .testTarget(
//            name: "ExtensionsTests",
//            dependencies: ["Extensions"]),
    ]
)
