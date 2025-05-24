// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyDrawer",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "SwiftyDrawer",
            targets: ["SwiftyDrawer"]
        )
    ],
    dependencies: [
//        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.58.2")
    ],
    targets: [
        .target(
            name: "SwiftyDrawer",
//            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
        .testTarget(
            name: "SwiftyDrawerTests",
            dependencies: ["SwiftyDrawer"]
        )
    ],
    swiftLanguageModes: [.v6]
)
