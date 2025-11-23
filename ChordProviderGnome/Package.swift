// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChordProvider",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "CChordProvider",
            targets: ["CChordProvider"]
        )
    ],
    dependencies: [
        .package(url: "https://git.aparoksha.dev/aparoksha/adwaita-swift", branch: "main"),
        .package(path: "../ChordProviderCore"),
        .package(path: "../GtkSourceView")
    ],
    targets: [
        .executableTarget(
            name: "ChordProvider",
            dependencies: [
                "CChordProvider",
                .product(name: "Adwaita", package: "adwaita-swift"),
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
                .product(name: "SourceView", package: "GtkSourceView")
            ],
            path: "Sources",
            resources: [
                .copy("Resources/nl.desbeers.chordprovider.svg"),
                .copy("Resources/nl.desbeers.chordprovider-symbolic.svg"),
                .copy("Resources/nl.desbeers.chordprovider-mime.svg"),
                .copy("Samples")
            ],
        ),
        .systemLibrary(
            name: "CChordProvider",
            pkgConfig: "cairo"
        )
    ]
)
