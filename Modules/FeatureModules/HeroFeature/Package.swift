// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HeroFeature",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "HeroFeature",
            targets: ["HeroFeature"]),
    ],
    dependencies: [
        .package(path: "../../CoreModules/CoreLibraries"),
        .package(path: "../../CoreModules/Extensions"),
    ],
    targets: [
        .target(
            name: "HeroFeature",
            dependencies: [
                "CoreLibraries",
                "Extensions"
            ]
        ),
    ]
)
