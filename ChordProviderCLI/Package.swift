// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "ChordProviderCLI",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "ChordProviderCLI",
            targets: ["ChordProviderCLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(path: "../ChordProviderCore")
    ],
    targets: [
        .executableTarget(
            name: "ChordProviderCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ChordProviderCore", package: "ChordProviderCore") 
            ]
        )
    ]
)
