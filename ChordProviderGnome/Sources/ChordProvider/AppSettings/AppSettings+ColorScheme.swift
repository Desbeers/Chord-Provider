//
//  AppSettings+ColorScheme.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    enum ColorScheme: String, Codable, Equatable, CaseIterable, CustomStringConvertible, Identifiable {
        case accent
        case green
        case red

        var id: Self { self }
        /// CustomStringConvertible protocol
        var description: String {
            switch self {
            case .accent:
                "System Accent"
            case .green:
                "Green Delight"
            case .red:
                "Red Delight"
            }
        }

        func colors(dark: Bool) -> Colors {
        switch self {
            case .accent:
                Colors.init(
                    windowStart: "color-mix(in srgb, var(--accent-bg-color) 10%, var(--window-bg-color))",
                    windowEnd: "var(--window-bg-color)",
                    chordColor: "var(--accent-bg-color)",
                    labelBackgroundColor: "color-mix(in srgb, var(--accent-bg-color) 40%, var(--window-bg-color))",
                    accentBackgroundColor: ""
                )
            case .green:
                Colors.init(
                    windowStart: dark ? "#121f16" : "#DCE3DD",
                    windowEnd: dark ? "#363426" : "#f8f4e2",
                    chordColor: dark ? "#cee3da" : "#78847f",
                    labelBackgroundColor: dark ? "#57575a" : "#c8d3ca",
                    accentBackgroundColor: dark ? "#858e8a" : "#78847f"
                )
            case .red:
                Colors.init(
                    windowStart: dark ? "#351117" : "#e3dcdd",
                    windowEnd: dark ? "#363426" : "#f8f4e2",
                    chordColor: dark ? "#f57a7a" : "#d30606",
                    labelBackgroundColor: dark ? "#1f1214" : "#e3dcdd",
                    accentBackgroundColor: dark ? "#8e8585" : "#847878"
                )
            }
        }
    }

    struct Colors {
        var windowStart: String
        var windowEnd: String
        var chordColor: String
        var labelBackgroundColor: String
        var accentBackgroundColor: String
    }
}
