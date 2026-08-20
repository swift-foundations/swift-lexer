// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-lexer",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Lexer",
            targets: ["Lexer"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-lexer-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-diagnostic-primitives.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Lexer",
            dependencies: [
                .product(name: "Lexer Primitives", package: "swift-lexer-primitives"),
                .product(name: "Diagnostic Primitives", package: "swift-diagnostic-primitives"),
            ]
        ),
        .testTarget(
            name: "Lexer Tests",
            dependencies: [
                "Lexer"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
