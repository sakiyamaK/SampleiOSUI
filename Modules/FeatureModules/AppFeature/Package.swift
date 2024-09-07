// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppFeature",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppFeature",
            targets: [
                "AppFeature"
            ]
        ),
    ],
    dependencies: [
        .package(path: "../CoreLibraries"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "CoreLibraries",
//                .target(name: "Extensions"),
//                .target(name: "Components"),
//                .target(name: "ChartFeature"),
//                .target(name: "SwiftUIHostingFeature"),
//                .target(name: "SampleTableFeature"),
//                .target(name: "SampleFeature"),
//                .target(name: "ZoomImageFeature"),
//                .target(name: "SampleAffineFeature"),
//                .target(name: "CollectionViewFeature"),
//                .target(name: "SampleTextViewFeature"),
//                .target(name: "ScrollNavigationBarFeature"),
//                .target(name: "TabNavigationFeature"),
//                .target(name: "ComposeForiOSNative"),
//                .target(name: "HeroFeature"),
//                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
//                .product(name: "Parchment", package: "Parchment"),
            ]
        ),
//        .target(
//            name: "Extensions",
//            dependencies: [
//                "CoreLibraries",
//                .product(name: "Parchment", package: "Parchment"),
//            ]
//        ),
//        .target(
//            name: "Components",
//            dependencies: [
//                "CoreLibraries",
//            ]
//        ),
//        
//            .target(
//                name: "ChartFeature",
//                dependencies: [
//                    "CoreLibraries",
//                    .product(name: "Charts", package: "Charts"),
//                ]
//            ),
//        .target(
//            name: "SwiftUIHostingFeature",
//            dependencies: [
//                .target(name: "Extensions"),
//                "CoreLibraries",
//            ]
//        ),
//        .target(
//            name: "SampleTableFeature",
//            dependencies: [
//                .target(name: "Extensions"),
//                "CoreLibraries",
//            ]
//        ),
//        .target(
//            name: "SampleFeature",
//            dependencies: [
//                .target(name: "ResourceFeature"),
//                .target(name: "Extensions"),
//                .target(name: "Components"),
//                "CoreLibraries",
//                .product(name: "Parchment", package: "Parchment"),
//                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),
//                .product(name: "Kingfisher", package: "Kingfisher"),
//                .product(name: "InjectionNext", package: "InjectionNext"),
//            ]
//        ),
//        .target(
//            name: "SampleAffineFeature",
//            dependencies: [
//                .target(name: "Extensions"),
//                .target(name: "ResourceFeature"),
//                "CoreLibraries",
//            ]
//        ),
//        .target(
//            name: "ResourceFeature",
//            dependencies: [.product(name: "RswiftLibrary", package: "R.swift")],
//            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift")]
//        ),
//        .target(
//            name: "SampleTextViewFeature",
//            dependencies: [
//                .target(name: "Extensions"),
//                .target(name: "Components"),
//                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
//                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
//            ]
//        ),
//        .target(
//            name: "ScrollNavigationBarFeature",
//            dependencies: [
//                .target(name: "Extensions"),
//                .target(name: "Components"),
//                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
//            ]
//        ),
//        .target(
//            name: "ZoomImageFeature",
//            dependencies: [
//            ]
//        ),
//        .target(
//            name: "CollectionViewFeature",
//            dependencies: [
//                .target(name: "Extensions"),
//                .target(name: "ResourceFeature"),                
//                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
//                .product(name: "Kingfisher", package: "Kingfisher"),
//                .product(name: "SnapKit", package: "SnapKit"),
//                .product(name: "Hero", package: "Hero"),
//                .product(name: "ModernCollectionView", package: "ModernCollectionView"),
//                .product(name: "InjectionNext", package: "InjectionNext"),
//            ]
//        ),
//        .target(
//            name: "TabNavigationFeature",
//            dependencies: [
//                .target(name: "Extensions"),
//                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
//            ]
//        ),
//        .target(
//            name: "ComposeForiOSNative",
//            dependencies: [
//                .target(name: "Extensions"),
//                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
//                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
//            ]
//        ),
//        .target(
//            name: "HeroFeature",
//            dependencies: [
//                .target(name: "Extensions"),
//                .target(name: "ResourceFeature"),                
//                .product(name: "DeclarativeUIKit", package: "DeclarativeUIKit"),
//                .product(name: "Hero", package: "Hero"),
//                .product(name: "ObservableUIKit", package: "ObservableUIKit"),
//            ]
//        )
        //        .testTarget(
        //            name: "AppTests",
        //            dependencies: ["AppFeature"]),
    ]
)
