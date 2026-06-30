//
//  AppSettings+ColorScheme.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// The color scheme for the application
    enum ColorScheme: String, Codable, Equatable, CaseIterable, CustomStringConvertible, Identifiable {
        /// The system accent color
        case accent
        /// Greenish color
        case green
        /// Reddish color
        case red
        /// Identifiable protocol
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
        /// The colors for the color scheme
        func colors(dark: Bool) -> Colors {
        switch self {
            case .accent:
                Colors(
                    windowStart: "color-mix(in srgb, var(--accent-bg-color) 6%, var(--accent-bg-color) 2%)",
                    windowEnd: "var(--window-bg-color)",
                    chordColor: "var(--accent-bg-color)",
                    labelBackgroundColor: "color-mix(in srgb, var(--accent-bg-color) 20%, var(--window-bg-color))",
                    // Ignored for the accent scheme for technical reasons
                    accentBackgroundColor: ""
                )
            case .green:
                Colors(
                    windowStart: dark ? "#121f16" : "#DCE3DD",
                    windowEnd: dark ? "#363426" : "#f8f4e2",
                    chordColor: dark ? "#cee3da" : "#78847f",
                    labelBackgroundColor: dark ? "#57575a" : "#c8d3ca",
                    accentBackgroundColor: dark ? "#858e8a" : "#78847f"
                )
            case .red:
                Colors(
                    windowStart: dark ? "#351117" : "#e3dcdd",
                    windowEnd: dark ? "#363426" : "#f8f4e2",
                    chordColor: dark ? "#f57a7a" : "#d30606",
                    labelBackgroundColor: dark ? "#1f1214" : "#e3dcdd",
                    accentBackgroundColor: dark ? "#8e8585" : "#847878"
                )
            }
        }
    }

    /// Colors for styles
    struct Colors {
        /// Color for the window in the left top corner
        var windowStart: String
        /// Color for the window in the right bottom corner
        var windowEnd: String
        /// Color for the chords
        var chordColor: String
        /// Color for section labels
        var labelBackgroundColor: String
        /// Background Color for accents 
        var accentBackgroundColor: String
    }
}
