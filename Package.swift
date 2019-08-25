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
        .package(url: "https://github.com/jflinter/Dwifft", .revision("6fec2bc0246091b3e17a9d42e722fb98e05ac3ff"))
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
