// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TabNavigaitonFeature",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TabNavigationFeature",
            targets: ["TabNavigationFeature"])
    ],
    dependencies: [
        .package(path: "../../CoreModules/CoreLibraries"),
        .package(path: "../../CoreModules/Components"),
        .package(path: "../../CoreModules/Extensions")
    ],
    targets: [
        .target(
            name: "TabNavigationFeature",
            dependencies: [
                "CoreLibraries",
                "Components",
                "Extensions",
            ]
        )
    ]
)
