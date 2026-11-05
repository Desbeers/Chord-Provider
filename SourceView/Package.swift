// swift-tools-version: 6.3

import PackageDescription

/// The dependencies
var dependencies: [Package.Dependency] = [
    .package(
        url: "https://codeberg.org/desbeers/adwaita-swift",
        branch: "main",
        traits: ["exposeGeneratedAppearUpdateFunctions"],
    )
]

#if os(Linux)
    dependencies.append(.package(url: "https://github.com/stephencelis/CSQLite", from: "3.50.4"))
#endif

/// The **SourceView** package
let package = Package(
    name: "SourceView",
    platforms: [
        .macOS(.v15)
    ],
    products: [

        // MARK: Executables

        // SourceView Demo
        .executable(
            name: "SourceViewDemo",
            targets: ["SourceViewDemo"]
        ),

        // MARK: Libraries

        // SourceView Library
        .library(
            name: "SourceView",
            targets: ["SourceView"]
        ),
    ],
    dependencies: dependencies,
    targets: [

        // MARK: Executables

        // Chord Provider GUI
        .executableTarget(
            name: "SourceViewDemo",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                "SourceView"
            ],
            path: "SourceViewDemo",
            resources: [
                .copy("Resources")
            ]
        ),

        // MARK: Libraries

        // SourceView library
        .target(
            name: "SourceView",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                "CSourceView",
                "CLibSpelling"
            ],
            path: "SourceView",
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
            path: "CSourceView",
            publicHeadersPath: "include"
        ),

        // MARK: System Libraries

        // GtkSourceView C stuff
        .systemLibrary(
            name: "CGtkSourceView",
            path: "CGtkSourceView",
            pkgConfig: "gtksourceview-5"
        ),
        // LibSpelling C stuff
        .systemLibrary(
            name: "CLibSpelling",
            path: "CLibSpelling",
            pkgConfig: "libspelling-1"
        )
    ]
)
