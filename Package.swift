// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CellKit",
    platforms: [.iOS(.v8), .tvOS(.v9)],
    products: [
        .library(
            name: "CellKit",
            targets: ["CellKit"]),

    ],
    targets: [
        .target(
            name: "CellKit",
            dependencies: [])
    ]
)
