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
        /// Color scheme
        var colorScheme: ColorScheme = .accent
        /// The zoom factor of the Render `View`
        var zoom: Double = 1
        /// The font size of the editor
        var editorFontSize: Int = 100
        /// The font size for chords
        var chordsFontSize: Int = 100

        /// Set the Pango accent color
        /// - Parameter dark: Bool if the theme is dark
        /// - Returns: The accent colors as `UInt16`
        func setPangoAccentColor(dark: Bool) -> (red: UInt16, green: UInt16, blue: UInt16) {
            var red: UInt16 = 0
            var green: UInt16 = 0
            var blue: UInt16 = 0
            switch self.colorScheme {
            case .accent:
                let styleManager = adw_style_manager_get_default()
                if let rgba = adw_style_manager_get_accent_color_rgba(styleManager) {
                    red   = UInt16(rgba.pointee.red   * 65535)
                    green = UInt16(rgba.pointee.green * 65535)
                    blue  = UInt16(rgba.pointee.blue  * 65535)
                }
            default:
                var rgba = GdkRGBA()
                gdk_rgba_parse(&rgba, self.colorScheme.colors(dark: dark).chordColor)
                red   = UInt16(rgba.red   * 65535)
                green = UInt16(rgba.green * 65535)
                blue  = UInt16(rgba.blue  * 65535)
            }
            return (red, green, blue)
        }
    }
}

extension AppSettings.Theme {

    /// The appearance of the application
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
