// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Components",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Components",
            targets: ["Components"]),
    ],
    dependencies: [
        .package(path: "../CoreLibraries"),
        .package(path: "../Extensions"),
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                "CoreLibraries",
                "Extensions"
            ]
        ),
//        .testTarget(
//            name: "ComponentsTests",
//            dependencies: ["Components"]),
    ]
)
