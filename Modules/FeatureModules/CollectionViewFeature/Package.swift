// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CollectionViewFeature",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CollectionViewFeature",
            targets: ["CollectionViewFeature"]),
    ],
    dependencies: [
        .package(path: "../../CoreModules/CoreLibraries"),
        .package(path: "../../CoreModules/Components"),
        .package(path: "../../CoreModules/Extensions"),
        .package(path: "../../CoreModules/Files"),
        .package(url: "https://github.com/HeroTransitions/Hero", from: "1.6.2"),
        .package(url: "https://github.com/sakiyamaK/ModernCollectionView", from: "0.0.7"),
        .package(url: "https://github.com/eddiekaiger/SwiftyAttributes", from: "5.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CollectionViewFeature",
            dependencies: [
                "CoreLibraries",
                "Components",
                "Extensions",
                "Files",
                .product(name: "ModernCollectionView", package: "ModernCollectionView"),
                .product(name: "Hero", package: "Hero"),
                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),
            ]
        )
//        .testTarget(
//            name: "CollectionViewFeatureTests",
//            dependencies: ["CollectionViewFeature"]),
    ]
)
