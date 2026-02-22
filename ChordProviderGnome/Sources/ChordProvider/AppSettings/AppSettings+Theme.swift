//
//  AppSettings+Theme.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CAdw

extension AppSettings {

    /// Settings for the theme
    struct Theme: Codable, Equatable {
        /// Appearance
        var appearance: Appearance = .system
        /// Colorfull Window
        var colorfullWindow: Bool = false
        /// The zoom factor of the Render `View`
        var zoom: Double = 1
        /// The font size of the editor
        var editorFontSize: Font = .standard
    }
}

extension AppSettings.Theme {
    enum Appearance: Int, Codable, Equatable, CaseIterable, CustomStringConvertible, Identifiable {
        /// Default appearance
        case system = 0
        /// Dark appearance
        case dark = 4
        /// Light appearance
        case light = 1
        /// Identifiable protocol
        var id: Self { self }
        /// CustomStringConvertible protocol
        var description: String {
            switch self {
            case .dark:
                "Prefer Dark"
            case .system:
                "No Preference"
            case .light:
                "Prefer Light"
            }
        }
        /// The Adwaita Color Scheme
        var colorScheme: AdwColorScheme {
            switch self {
            case .system:
                ADW_COLOR_SCHEME_DEFAULT
            case .dark:
                ADW_COLOR_SCHEME_FORCE_DARK
            case .light:
                ADW_COLOR_SCHEME_FORCE_LIGHT
            }
        }
    }
}

extension AppSettings.Theme {

    /// The font size of the editor
    enum Font: Int, Codable, CaseIterable, CustomStringConvertible, Identifiable {
        case smaller = 10
        case small = 11
        case standard = 12
        case large = 13
        case larger = 14

        var description: String {
            switch self {
            case .smaller: "Smaller"
            case .small: "Small"
            case .standard: "Standard"
            case .large: "Large"
            case .larger: "Larger"
            }
        }
        var id: Self { self }
    }
}