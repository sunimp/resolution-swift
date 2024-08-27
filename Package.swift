// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DomainsResolution",
    platforms: [.macOS(.v10_15), .iOS(.v14) ],
    products: [
        .library(
            name: "DomainsResolution",
            type: nil,
            targets: ["DomainsResolution"])
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.8.3")),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.0.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.54.0"),
    ],
    targets: [
        .target(
            name: "DomainsResolution",
            dependencies: ["CryptoSwift", "BigInt"],
            resources: [
                .process("Resources/UNS/resolver-keys.json"),
                .process("Resources/UNS/unsProxyReader.json"),
                .process("Resources/UNS/unsRegistry.json"),
                .process("Resources/UNS/cnsRegistry.json"),
                .process("Resources/UNS/unsResolver.json"),
                .process("Resources/UNS/uns-config.json")
            ],
            swiftSettings: [.define("INSIDE_PM")]
        ),
        .testTarget(
            name: "ResolutionTests",
            dependencies: ["DomainsResolution"],
            exclude: ["Info.plist"],
            swiftSettings: [.define("INSIDE_PM")]
        )
    ]
)
