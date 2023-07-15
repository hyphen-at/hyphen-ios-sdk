// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Hyphen",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "HyphenCore",
            targets: ["HyphenCore"]
        ),
        .library(
            name: "HyphenAuthenticate",
            targets: ["HyphenAuthenticate"]
        ),
        .library(
            name: "HyphenNetwork",
            targets: ["HyphenNetwork"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.11.0")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
        .package(url: "https://github.com/SomeRandomiOSDev/CBORCoding.git", from: "1.0.0"),
        .package(url: "https://github.com/Kitura/BlueECC", branch: "master"),
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
                .target(name: "HyphenNetwork"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                // .product(name: "CBORCoding", package: "CBORCoding"),
                .product(name: "CryptorECC", package: "BlueECC")
            ],
            path: "HyphenAuthenticate/Sources"
        ),
        .target(
            name: "HyphenNetwork",
            dependencies: [
                .target(name: "HyphenCore"),
                .product(name: "Moya", package: "Moya"),
            ],
            path: "HyphenNetwork/Sources"
        ),
    ]
)
