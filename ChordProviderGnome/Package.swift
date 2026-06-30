// swift-tools-version: 6.3

import PackageDescription

/// The dependencies
var dependencies: [Package.Dependency] = [
	.package(
            url: "https://git.aparoksha.dev/aparoksha/adwaita-swift",
            branch: "main",
            traits: ["exposeGeneratedAppearUpdateFunctions"],
    ),
    .package(path: "../ChordProviderCore"),
    .package(path: "../ChordProviderMIDI"),
    .package(path: "../ChordProviderEditor")
]

#if os(Linux)
    dependencies.append(.package(url: "https://github.com/stephencelis/CSQLite", from: "3.50.4"))
#endif

let package = Package(
    name: "ChordProviderGnome",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "ChordProviderGnome",
            targets: ["ChordProviderGnome"]
        )
    ],
    dependencies: dependencies,
    targets: [
        .executableTarget(
            name: "ChordProviderGnome",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
                .product(name: "ChordProviderEditor", package: "ChordProviderEditor"),
                .product(name: "ChordProviderMIDI", package: "ChordProviderMIDI")
            ],
            exclude: [
                "Resources/nl.desbeers.chordprovider.desktop",
                "Resources/nl.desbeers.chordprovider.metainfo.xml",
                "Resources/nl.desbeers.chordprovider.mime.xml"
            ],
            resources: [
                .copy("Resources/nl.desbeers.chordprovider.svg"),
                .copy("Resources/nl.desbeers.chordprovider-symbolic.svg"),
                .copy("Resources/nl.desbeers.chordprovider-mime.svg"),
                .copy("Samples")
            ],
        )
    ]
)
