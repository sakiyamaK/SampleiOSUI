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
        .package(path: "../HeroFeature"),
        .package(path: "../SampleTextViewFeature"),
        .package(path: "../ScrollNavigationBarFeature"),
        .package(path: "../SwiftUIHostingFeature"),
        .package(path: "../TabNavigaitonFeature"),
        .package(path: "../ZoomImageFeature"),
        .package(path: "../ChartFeature"),
        .package(path: "../CollectionViewFeature"),
        .package(path: "../ComposeForiOSNative"),
        .package(path: "../SampleAffineFeature"),
        .package(path: "../SampleFeature"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "HeroFeature",
                "SampleTextViewFeature",
                "ScrollNavigationBarFeature",
                "SwiftUIHostingFeature",
                "TabNavigaitonFeature",
                "ZoomImageFeature",
                "ChartFeature",
                "CollectionViewFeature",
                "ComposeForiOSNative",
                "SampleAffineFeature",
                "SampleFeature",
            ]
        )
        //        .testTarget(
        //            name: "AppTests",
        //            dependencies: ["AppFeature"]),
    ]
)
