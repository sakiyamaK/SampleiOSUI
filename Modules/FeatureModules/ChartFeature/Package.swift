// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChartFeature",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ChartFeature",
            targets: ["ChartFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danielgindi/Charts", from: "4.1.0"),
        .package(path: "../../CoreModules/CoreLibraries"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ChartFeature",
            dependencies: [
                .product(name: "Charts", package: "Charts"),
                "CoreLibraries",
            ]
        ),
//        .testTarget(
//            name: "ChartFeatureTests",
//            dependencies: ["ChartFeature"]),
    ]
)
