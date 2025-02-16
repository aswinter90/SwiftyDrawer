// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIDrawer",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "SwiftUIDrawer",
            targets: ["SwiftUIDrawer"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.58.2")
    ],
    targets: [
        .target(
            name: "SwiftUIDrawer",
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
        .testTarget(
            name: "SwiftUIDrawerTests",
            dependencies: ["SwiftUIDrawer"]
        ),
    ]
)
