// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-lexer",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Lexer",
            targets: ["Lexer"]
        )
    ],
    dependencies: [
        .package(path: "../swift-primitives/swift-lexer-primitives"),
        .package(path: "../swift-primitives/swift-diagnostic-primitives")
    ],
    targets: [
        .target(
            name: "Lexer",
            dependencies: [
                .product(name: "Lexer Primitives", package: "swift-lexer-primitives"),
                .product(name: "Diagnostic Primitives", package: "swift-diagnostic-primitives")
            ]
        ),
        .testTarget(
            name: "Lexer Tests",
            dependencies: [
                "Lexer",
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
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
