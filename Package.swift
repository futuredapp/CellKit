// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CellKit",
    platforms: [.iOS(.v8), .tvOS(.v9)],
    products: [
        .library(
            name: "CellKit",
            targets: ["CellKit"]),
        .library(
            name: "DiffableCellKit",
            targets: ["DiffableCellKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/DenTelezhkin/Dwifft", .branch("swift-pm"))
    ],
    targets: [
        .target(
            name: "CellKit",
            dependencies: []),
        .target(
            name: "DiffableCellKit",
            dependencies: ["CellKit", "Dwifft"])
    ]
)
