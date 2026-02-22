// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// The dependencies.
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
    dependencies: dependencies,
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
        .executableTarget(
            name: "ChordProvider",
            dependencies: [
                "SourceView",
                "CFluidSynth",
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
            name: "GenerateSnippets",
            dependencies: [
                .product(name: "ChordProviderCore", package: "ChordProviderCore"),
            ],
        ),
        .systemLibrary(
            name: "CGtkSourceView",
            pkgConfig: "gtksourceview-5"
        ),
        .systemLibrary(
            name: "CFluidSynth",
            pkgConfig: "fluidsynth"
        )
    ]
)
