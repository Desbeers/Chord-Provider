// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "ChordProviderCore",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "ChordProviderCore",
            targets: ["ChordProviderCore"]
        )
    ],
    targets: [
        .target(
            name: "ChordProviderCore",
            resources: [
                .copy("ChordDefinitions"),
                .copy("Resources/Icons"),
                .copy("Resources/Strums"),
                .copy("Resources/GuitarSoundFont.sf2")
            ],

        )
    ]
)
