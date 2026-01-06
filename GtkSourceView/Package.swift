// swift-tools-version: 6.1
//
//  Package.swift
//  GTKSourceView
//
//  © 2025 Nick Berendsen
//

import PackageDescription

/// The SourceView package.
let package = Package(
    name: "GtkSourceView",
    platforms: [.macOS(.v15)],
    products: [
        .library(
            name: "SourceView",
            targets: ["SourceView"]
        ),
        .library(
            name: "CSourceView",
            targets: ["CSourceView"]
        ),
        .library(
            name: "CGtkSourceView",
            targets: ["CGtkSourceView"]
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
                "CGtkSourceView",
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
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include")
            ]
        ),
        .systemLibrary(
            name: "CGtkSourceView",
            pkgConfig: "gtksourceview-5"
        )
    ]
)
