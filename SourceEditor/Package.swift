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

/// The **SourceEditor** package
let package = Package(
    name: "SourceEditor",
    platforms: [
        .macOS(.v15)
    ],
    products: [

        // MARK: Libraries

        // SourceEditor Library
        .library(
            name: "SourceEditor",
            targets: ["SourceEditor"]
        ),
    ],
    dependencies: dependencies,
    targets: [

        // MARK: Executables

        // SourceEditor Demo
        .executableTarget(
            name: "Demo",
            dependencies: [
                "SourceEditor"
            ],
            path: "Package/Demo",
            resources: [
                .copy("Resources")
            ]
        ),

        // MARK: Libraries

        // SourceEditor library
        .target(
            name: "SourceEditor",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                "CSourceEditor",
                "CLibSpelling"
                // "Schemes"
            ],
            path: "Package/SourceEditor",
            resources: [
                .copy("Resources")
            ]
        ),
        // C stuff for the editor library
        .target(
            name: "CSourceEditor",
            dependencies: [
                "CGtkSourceView"
            ],
            path: "Package/CSourceEditor",
            publicHeadersPath: "Headers"
        ),

        // MARK: System Libraries

        // GtkSourceView C stuff
        .systemLibrary(
            name: "CGtkSourceView",
            path: "Package/CGtkSourceView",
            pkgConfig: "gtksourceview-5"
        ),
        // LibSpelling C stuff
        .systemLibrary(
            name: "CLibSpelling",
            path: "Package/CLibSpelling",
            pkgConfig: "libspelling-1"
        )
    ]
)
