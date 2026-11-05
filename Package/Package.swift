// swift-tools-version: 6.3

import PackageDescription

/// The dependencies
var dependencies: [Package.Dependency] = [
    .package(
        url: "https://codeberg.org/desbeers/adwaita-swift",
        branch: "main",
        traits: ["exposeGeneratedAppearUpdateFunctions"],
    ),
    .package(
        url: "https://github.com/apple/swift-argument-parser.git",
        from: "1.2.0"
    ),
    .package(
        url: "https://github.com/apple/swift-docc-plugin",
        from: "1.0.0"
    )
]

#if os(Linux)
    dependencies.append(.package(url: "https://github.com/stephencelis/CSQLite", from: "3.50.4"))
#endif

/// The **Chord Provider** package
let package = Package(
    name: "ChordProvider",
    platforms: [
        .macOS(.v15)
    ],
    products: [

        // MARK: Executables

        // Chord Provider CLI
        .executable(
            name: "ChordProviderCLI",
            targets: ["ChordProviderCLI"]
        ),
        // Chord Provider GUI
        .executable(
            name: "ChordProviderGnome",
            targets: ["ChordProviderGnome"]
        ),
        // Generate snippets for editor and documentation
        .executable(
            name: "GenerateSnippets",
            targets: ["GenerateSnippets"]
        ),
        // Source View Demo
        .executable(
            name: "SourceViewDemo",
            targets: ["SourceViewDemo"]
        ),

        // MARK: Libraries

        // Core library
        .library(
            name: "ChordProviderCore",
            targets: ["ChordProviderCore"]
        ),
        // Editor library
        .library(
            name: "SourceView",
            targets: ["SourceView"]
        )
    ],
    dependencies: dependencies,
    targets: [

        // MARK: Executables

        // Chord Provider CLI
        .executableTarget(
            name: "ChordProviderCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ChordProviderCore"
            ],
            path: "ChordProviderCLI",
        ),
        // Chord Provider GUI
        .executableTarget(
            name: "ChordProviderGnome",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                "ChordProviderCore",
                "SourceView",
                "ChordProviderMIDI"
            ],
            path: "ChordProviderGnome",
            exclude: [
                "Resources/nl.desbeers.chordprovider.desktop",
                "Resources/nl.desbeers.chordprovider.metainfo.xml",
                "Resources/nl.desbeers.chordprovider.mime.xml"
            ],
            resources: [
                .copy("Resources/nl.desbeers.chordprovider.svg"),
                .copy("Resources/nl.desbeers.chordprovider-symbolic.svg"),
                .copy("Resources/nl.desbeers.chordprovider-mime.svg"),
                .copy("Resources/chordpro.snippets"),
                .copy("Samples")
            ]
        ),
        // Generate snippets for editor and documentation
        .executableTarget(
            name: "GenerateSnippets",
            dependencies: [
                "ChordProviderCore"
            ],
            path: "GenerateSnippets",
        ),
        // Source View Demo
        .executableTarget(
            name: "SourceViewDemo",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                "SourceView"
            ],
            path: "SourceView/SourceViewDemo",
        ),

        // MARK: Libraries

        // Core library
        .target(
            name: "ChordProviderCore",
            path: "ChordProviderCore",
            resources: [
                .copy("ChordDefinitions"),
                .copy("Resources/Icons"),
                .copy("Resources/Strums"),
                .copy("Resources/GuitarSoundFont.sf2")
            ],
        ),
        // Editor library
        .target(
            name: "SourceView",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                "CSourceView",
                "CLibSpelling"
            ],
            path: "SourceView/SourceView",
            resources: [
                .copy("Resources")
            ]
        ),
        // C stuff for the editor library
        .target(
            name: "CSourceView",
            dependencies: [
                "CGtkSourceView"
            ],
            path: "SourceView/CSourceView",
            publicHeadersPath: "include"
        ),
        // MIDI player library
        .target(
            name: "ChordProviderMIDI",
            dependencies: [
                "ChordProviderCore",
                "CFluidSynth"
            ],
            path: "ChordProviderMIDI/ChordProviderMIDI"
        ),
        // Empty target that builds the DocC catalog at /Resources/Documentation.docc.
        .target(
            name: "ChordProviderDocs",
            dependencies: [
                "ChordProviderCore",
                "ChordProviderGnome",
                "SourceView",
                "ChordProviderMIDI",
                "ChordProviderCLI"
            ],
            path: "ChordProviderDocs",
        ),

        // MARK: System Libraries

        // GtkSourceView C stuff
        .systemLibrary(
            name: "CGtkSourceView",
            path: "SourceView/CGtkSourceView",
            pkgConfig: "gtksourceview-5"
        ),
        // FluidSynth C stuff
        .systemLibrary(
            name: "CFluidSynth",
            path: "ChordProviderMIDI/CFluidSynth",
            pkgConfig: "fluidsynth"
        ),
        // LibSpelling C stuff
        .systemLibrary(
            name: "CLibSpelling",
            path: "SourceView/CLibSpelling",
            pkgConfig: "libspelling-1"
        )
    ]
)
