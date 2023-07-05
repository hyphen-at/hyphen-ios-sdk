// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Hyphen",
    products: [
        .library(
            name: "HyphenCore",
            targets: ["HyphenCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "HyphenCore",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
            ],
            path: "HyphenCore/Sources"
        ),
    ]
)
