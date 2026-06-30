// swift-tools-version: 6.3

import PackageDescription

/// The dependencies
var dependencies: [Package.Dependency] = [
	.package(
            url: "https://git.aparoksha.dev/aparoksha/adwaita-swift",
            branch: "main",
            traits: ["exposeGeneratedAppearUpdateFunctions"],
    ),
    .package(path: "../ChordProviderCore")
]

#if os(Linux)
    dependencies.append(.package(url: "https://github.com/stephencelis/CSQLite", from: "3.50.4"))
#endif

let package = Package(
    name: "ChordProviderEditor",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "ChordProviderEditor",
            targets: ["ChordProviderEditor"]
        ),
        .executable(
            name: "GenerateSnippets",
            targets: ["GenerateSnippets"]
        )
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "ChordProviderEditor",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
                "CChordProviderEditor"
            ],
            resources: [
                .copy("Resources/chordpro.lang"),
                .copy("Resources/chordpro.snippets")
            ],
        ),
        .target(
            name: "CChordProviderEditor",
            dependencies: [
                "CGtkSourceView"
            ],
            publicHeadersPath: "include"
        ),
        .systemLibrary(
            name: "CGtkSourceView",
            pkgConfig: "gtksourceview-5"
        ),
        .executableTarget(
            name: "GenerateSnippets",
            dependencies: [
                .product(name: "ChordProviderCore", package: "ChordProviderCore")
            ],
        )
    ]
)
