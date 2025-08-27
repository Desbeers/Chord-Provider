// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chord Provider",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://git.aparoksha.dev/aparoksha/adwaita-swift", branch: "main"),
        .package(url: "https://git.aparoksha.dev/aparoksha/localized", branch: "main"),
        .package(path: "../ChordProviderCore"),
        .package(path: "../ChordProviderHTML")
    ],
    targets: [
        .executableTarget(
            name: "Chord Provider",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                .product(name: "Localized", package: "localized"),
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
                .product(name: "ChordProviderHTML", package: "ChordProviderHTML")
            ],
            path: "Sources",
            resources: [
                .process("Localized.yml")
            ],
            plugins: [
                .plugin(name: "GenerateLocalized", package: "localized")
            ]
        )
    ],
    swiftLanguageModes: [.v5]
)
