// swift-tools-version: 6.1
//
//  Package.swift
//  GTKSourceView
//
//  © 2025 Nick Berendsen
//

import PackageDescription

/// The CodeEditor package.
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
        )
    ],
    dependencies: [
        .package(url: "https://git.aparoksha.dev/aparoksha/adwaita-swift", branch: "main")
    ],
    targets: [
        .target(
            name: "SourceView",
            dependencies: [.product(name: "Adwaita", package: "adwaita-swift"), "CSourceView"],
            resources: [
                .copy("Resources/chordpro.lang")
            ],
        ),
        .systemLibrary(
            name: "CSourceView",
            pkgConfig: "gtksourceview-5"
        )
    ]
)
