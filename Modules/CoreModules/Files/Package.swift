// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Files",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Files",
            targets: ["Files"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mac-cain13/R.swift", from: "7.5.0"),
    ],
    targets: [
        .target(
            name: "Files",
            dependencies: [
                .product(name: "RswiftLibrary", package: "R.swift"),
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
            ]
        )
    ]
)
