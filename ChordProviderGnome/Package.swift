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
            name: "SourceView",
            targets: ["SourceView"]
        )
    ],
    dependencies: [
        .package(url: "https://git.aparoksha.dev/aparoksha/adwaita-swift", branch: "main"),
        .package(path: "../ChordProviderCore")
    ],
    targets: [
        .target(
            name: "SourceView",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
                "CSourceView"
            ],
            resources: [
                .copy("Resources/chordpro.lang"),
                .copy("Resources/chordpro.snippets")
            ],
        ),
        .target(
            name: "CSourceView",
            dependencies: [
                "CGtkSourceView"
            ],
            publicHeadersPath: "include"
        ),
        .target(
            name: "CChordProvider",
            dependencies: [
                "CSourceView"
            ],
            publicHeadersPath: "include"
        ),
        .executableTarget(
            name: "ChordProvider",
            dependencies: [
                "CChordProvider",
                "SourceView",
                .product(name: "Adwaita", package: "adwaita-swift"),
                .product(name: "ChordProviderCore", package: "ChordProviderCore")
            ],
            resources: [
                .copy("Resources/nl.desbeers.chordprovider.svg"),
                .copy("Resources/nl.desbeers.chordprovider-symbolic.svg"),
                .copy("Resources/nl.desbeers.chordprovider-mime.svg"),
                .copy("Samples")
            ],
        ),
        .executableTarget(
            name: "Generate",
            dependencies: [
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
            ],
            path: "Generate",
        ),
        .systemLibrary(
            name: "CGtkSourceView",
            pkgConfig: "gtksourceview-5"
        )
    ]
)
