// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SampleAffineFeature",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SampleAffineFeature",
            targets: ["SampleAffineFeature"]),
    ],
    dependencies: [
        .package(path: "../../CoreModules/CoreLibraries"),
        .package(path: "../../CoreModules/Components"),
        .package(path: "../../CoreModules/Extensions"),
        .package(path: "../../CoreModules/Files"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SampleAffineFeature",
            dependencies: [
                "CoreLibraries",
                "Components",
                "Extensions",
                "Files",
            ],
            resources: [
                .copy("../Resources/A.xcassets"),
                .copy("../B.xcassets"),
                .copy("C.xcassets"),
            ]
        ),
//        .testTarget(
//            name: "SampleAffineFeatureTests",
//            dependencies: ["SampleAffineFeature"]),
    ]
)
