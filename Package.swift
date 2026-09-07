// swift-tools-version:6.2

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .defaultIsolation(MainActor.self),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances")
]

let package = Package(
    name: "CellKit",
    platforms: [.iOS(.v15), .tvOS(.v15)],
    products: [
        .library(
            name: "CellKit",
            targets: ["CellKit"]),
        .library(
            name: "DiffableCellKit",
            targets: ["DiffableCellKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/ra1028/DifferenceKit.git", from: "1.3.0")
    ],
    targets: [
        .target(
            name: "CellKit",
            dependencies: [],
            swiftSettings: swiftSettings),
        .target(
            name: "DiffableCellKit",
            dependencies: ["CellKit", "DifferenceKit"],
            swiftSettings: swiftSettings)
    ]
)
