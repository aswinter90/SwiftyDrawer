// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyDrawer",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftyDrawer",
            targets: ["SwiftyDrawer"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.58.2")
    ],
    targets: [
        .target(
            name: "SwiftyDrawer",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
        .testTarget(
            name: "SwiftyDrawerTests",
            dependencies: ["SwiftyDrawer"]
        )
    ]
)
