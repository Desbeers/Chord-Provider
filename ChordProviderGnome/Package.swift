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
            name: "CGtk",
            targets: ["CGtk"]
        )
    ],
    dependencies: [
        .package(url: "https://git.aparoksha.dev/aparoksha/adwaita-swift", branch: "main"),
        .package(path: "../ChordProviderCore"),
        .package(path: "../GtkSourceView")
    ],
    targets: [
        .target(
            name: "CChordProvider",
            dependencies: [
                "CGtk"
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include")
            ]
        ),
        .executableTarget(
            name: "ChordProvider",
            dependencies: [
                "CChordProvider",
                .product(name: "Adwaita", package: "adwaita-swift"),
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
                .product(name: "SourceView", package: "GtkSourceView")
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
            name: "CGtk",
            pkgConfig: "gtk4"
        )
    ]
)
