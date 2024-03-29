// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Hyphen",
    platforms: [
        .iOS(.v15),
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
        .library(
            name: "HyphenUI",
            targets: ["HyphenUI"]
        ),
        .library(
            name: "HyphenFlow",
            targets: ["HyphenFlow"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.11.0")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
        .package(url: "https://github.com/vpeschenkov/SecureDefaults", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/malcommac/RealEventsBus.git", branch: "main"),
        .package(url: "https://github.com/outblock/flow-swift.git", from: "0.3.4"),
        .package(url: "https://github.com/CoolONEOfficial/NativePartialSheet", from: "2.0.5"),
        // .package(url: "https://github.com/SomeRandomiOSDev/CBORCoding.git", from: "1.0.0"),
        // .package(url: "https://github.com/Kitura/BlueECC", branch: "master"),
        // .package(url: "https://github.com/gematik/ASN1Kit", branch: "main"),
    ],
    targets: [
        .target(
            name: "HyphenCore",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "SecureDefaults", package: "SecureDefaults"),
                .product(name: "RealEventsBus", package: "RealEventsBus"),
            ],
            path: "HyphenCore/Sources"
        ),
        .target(
            name: "HyphenAuthenticate",
            dependencies: [
                .target(name: "HyphenCore"),
                .target(name: "HyphenFlow"),
                .target(name: "HyphenNetwork"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "Flow", package: "flow-swift"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "Moya", package: "Moya"),
                .product(name: "RealEventsBus", package: "RealEventsBus"),
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
        .target(
            name: "HyphenUI",
            dependencies: [
                .target(name: "HyphenCore"),
                .target(name: "HyphenNetwork"),
                .target(name: "HyphenFlow"),
                .product(name: "NativePartialSheet", package: "NativePartialSheet"),
                .product(name: "RealEventsBus", package: "RealEventsBus"),
            ],
            path: "HyphenUI/Sources",
            resources: [
                .process("Resources/HyphenIcons.xcassets"),
                .process("Resources/HyphenColors.xcassets"),
            ]
        ),
        .target(
            name: "HyphenFlow",
            dependencies: [
                .target(name: "HyphenCore"),
                .target(name: "HyphenNetwork"),
                .product(name: "RealEventsBus", package: "RealEventsBus"),
                .product(name: "Flow", package: "flow-swift"),
            ],
            path: "HyphenFlow/Sources"
        ),
    ]
)
