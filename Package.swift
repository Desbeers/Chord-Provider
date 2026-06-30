// swift-tools-version: 6.3

import Foundation
import PackageDescription

/// The dependencies.
var dependencies: [Package.Dependency] = [
    .package(path: "./ChordProviderCore"),
    .package(path: "./ChordProviderGnome"),
    .package(path: "./ChordProviderCLI"),
    .package(path: "./ChordProviderMIDI"),
    .package(path: "./ChordProviderEditor"),
    .package(
        url: "https://github.com/apple/swift-docc-plugin",
        from: "1.0.0"
    )
]

let package = Package(
    name: "ChordProviderDocs",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "GenerateDocSnippets",
            targets: ["GenerateDocSnippets"]
        )
    ],
    dependencies: dependencies,
    targets: [
        // Empty target that builds the DocC catalog at /Resources/Documentation.docc.
        .target(
            name: "ChordProviderDocs",
            dependencies: [
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
                .product(name: "ChordProviderGnome", package: "ChordProviderGnome"),
                .product(name: "ChordProviderEditor", package: "ChordProviderEditor"),
                .product(name: "ChordProviderMIDI", package: "ChordProviderMIDI"),
                .product(name: "ChordProviderCLI", package: "ChordProviderCLI")
            ],
            path: "Resources/GenerateDocs",
        ),
        .executableTarget(
            name: "GenerateDocSnippets",
            dependencies: [
                .product(name: "ChordProviderCore", package: "ChordProviderCore")
            ],
            path: "Resources/GenerateDocSnippets",
        )
    ]
)
