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
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxOptional", from: "5.0.5"),
        .package(url: "https://github.com/RxSwiftCommunity/NSObject-Rx", from: "5.2.2"),
        .package(url: "https://github.com/eddiekaiger/SwiftyAttributes", from: "5.3.0"),
    ],
    targets: [
        .target(
            name: "SampleFeature",
            dependencies: [
                "CoreLibraries",
                "Components",
                "Extensions",
                "Files",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxOptional", package: "RxOptional"),
                .product(name: "NSObject-Rx", package: "NSObject-Rx"),
                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),
            ]
        ),
//        .testTarget(
//            name: "SampleFeatureTests",
//            dependencies: ["SampleFeature"]),
    ]
)
