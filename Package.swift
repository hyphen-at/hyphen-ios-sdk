// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Hyphen",
    products: [
        .library(
            name: "HyphenCore",
            targets: ["HyphenCore"]
        ),
        .library(
            name: "HyphenAuthenticate",
            targets: ["HyphenAuthenticate"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.11.0")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", .upToNextMajor(from: "7.0.0")),
    ],
    targets: [
        .target(
            name: "HyphenCore",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
            ],
            path: "HyphenCore/Sources"
        ),
        .target(
            name: "HyphenAuthenticate",
            dependencies: [
                .target(name: "HyphenCore"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
            ],
            path: "HyphenAuthenticate/Sources"
        ),
    ]
)
