// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SampleFeature",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SampleFeature",
            targets: ["SampleFeature"]),
    ],    
    dependencies: [
        .package(path: "../../CoreModules/CoreLibraries"),
        .package(path: "../../CoreModules/Components"),
        .package(path: "../../CoreModules/Extensions"),
        .package(path: "../../CoreModules/Files"),
    ],
    targets: [
        .target(
            name: "SampleFeature",
            dependencies: [
                "CoreLibraries",
                "Components",
                "Extensions",
                "Files",
            ]
        ),
//        .testTarget(
//            name: "SampleFeatureTests",
//            dependencies: ["SampleFeature"]),
    ]
)
