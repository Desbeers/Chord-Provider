// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "chordprovider",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(name: "chordprovider", targets: ["chordprovider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(path: "../ChordProviderCore")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "chordprovider",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ChordProviderCore", package: "ChordProviderCore")
            ]
        ),
    ]
)
