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
        .library(
            name: "AppFeature",
            targets: [
                "AppFeature"
            ]
        ),
    ],
    dependencies: [
        .package(path: "../../CoreModules/Files"),
        .package(path: "../../CoreModules/CoreLibraries"),
        .package(path: "../../CoreModules/Components"),
        .package(path: "../../CoreModules/Extensions"),
        .package(path: "../HeroFeature"),
        .package(path: "../SampleTextViewFeature"),
        .package(path: "../ScrollNavigationBarFeature"),
        .package(path: "../ZoomImageFeature"),
        .package(path: "../ChartFeature"),
        .package(path: "../CollectionViewFeature"),
        .package(path: "../SampleAffineFeature"),
        .package(path: "../SampleFeature"),
        // ここから下はなぜかPreviewでエラーがでる
                .package(path: "../TabNavigationFeature"),
//            .package(path: "../SwiftUIHostingFeature"),
        //        .package(path: "../ComposeForiOSNative"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "Files",
                "CoreLibraries",
                "Components",
                "Extensions",
                "HeroFeature",
                "SampleTextViewFeature",
                "ScrollNavigationBarFeature",
                "ZoomImageFeature",
                "ChartFeature",
                "CollectionViewFeature",
                "SampleAffineFeature",
                "SampleFeature",
                "TabNavigationFeature",
//                "SwiftUIHostingFeature",
                //                "ComposeForiOSNative",
            ]
        )
        //        .testTarget(
        //            name: "AppTests",
        //            dependencies: ["AppFeature"]),
    ]
)
