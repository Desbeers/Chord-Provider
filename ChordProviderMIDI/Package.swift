// swift-tools-version: 6.3

import PackageDescription

/// The dependencies.
var dependencies: [Package.Dependency] = [
    .package(path: "../ChordProviderCore")
]

let package = Package(
    name: "ChordProviderMIDI",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "ChordProviderMIDI",
            targets: ["ChordProviderMIDI"]
        )
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "ChordProviderMIDI",
            dependencies: [
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
                "CFluidSynth"
            ],
            resources: [
            ],
        ),
        .systemLibrary(
            name: "CFluidSynth",
            pkgConfig: "fluidsynth"
        )
    ]
)
