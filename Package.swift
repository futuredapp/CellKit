// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CellKit",
    platforms: [.iOS(.v9), .tvOS(.v9)],
    products: [
        .library(
            name: "CellKit",
            targets: ["CellKit"]),
        .library(
            name: "DiffableCellKit",
            targets: ["DiffableCellKit"])
    ],
    dependencies: [
    .package(url: "https://github.com/ra1028/DifferenceKit.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "CellKit",
            dependencies: []),
        .target(
            name: "DiffableCellKit",
            dependencies: ["CellKit", "DifferenceKit"])
    ]
)
