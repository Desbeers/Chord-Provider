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
        .package(path: "../ChordProviderHTML"),
        .package(path: "../GtkSourceView")
    ],
    targets: [
        .executableTarget(
            name: "ChordProvider",
            dependencies: [
                "CChordProvider",
                .product(name: "Adwaita", package: "adwaita-swift"),
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
                .product(name: "ChordProviderHTML", package: "ChordProviderHTML"),
                .product(name: "SourceView", package: "GtkSourceView")
            ],
            path: "Sources",
            resources: [
                .copy("Resources/nl.desbeers.chordprovider.svg"),
                .copy("Resources/nl.desbeers.chordprovider-symbolic.svg"),
                .copy("Resources/nl.desbeers.chordprovider-mime.svg"),
                .copy("Resources/capo.svg"),
                .copy("Resources/instrument.svg"),
                .copy("Resources/key.svg"),
                .copy("Resources/tempo.svg"),
                .copy("Resources/time.svg"),
                .copy("Samples")
            ],
        ),
        .systemLibrary(
            name: "CChordProvider",
            pkgConfig: "cairo"
        )
    ]
)
