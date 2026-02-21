// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Adwaita Debug",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://git.aparoksha.dev/aparoksha/adwaita-swift", branch: "main"),
        .package(url: "https://git.aparoksha.dev/aparoksha/localized", branch: "main"),
        .package(url: "https://github.com/stephencelis/CSQLite", from: "3.50.4")
    ],
    targets: [
        .executableTarget(
            name: "AdwaitaDebug",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                .product(name: "Localized", package: "localized")
            ],
            path: "Sources",
            resources: [
                .process("Localized.yml")
            ],
            plugins: [
                .plugin(name: "GenerateLocalized", package: "localized")
            ]
        )
    ]
)
