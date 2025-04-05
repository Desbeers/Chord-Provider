//
//  AppSettings+Style.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension AppSettings {

    /// Settings for displaying a song
    /// - Note: Following more or less the config of the official **ChordPro** reference implementation
    struct Style: Codable, Equatable {
        /// Theme
        var theme: Theme = Theme()
        /// Fonts
        var fonts: Fonts = Fonts()
    }
}

extension AppSettings.Style {

    /// Color Presets
    enum ColorPreset: String, CaseIterable {
        /// The *light* theme
        case light = "Light"
        /// The *dark* theme
        case dark = "Dark"
        /// Just for fun; random colours!
        case random = "Random"

        /// Add colours to the style settings
        /// - Parameter style: The current style
        /// - Returns: An updated style
        func presets(style: AppSettings.Style) -> AppSettings.Style {

            var appSettings = style

            switch self {
            case .light:
                appSettings.theme.foreground = .black
                appSettings.theme.foregroundMedium = .gray
                appSettings.theme.background = .white
                appSettings.fonts.title.color = .black
                appSettings.fonts.subtitle.color = .gray
                appSettings.fonts.chord.color = .accent
                appSettings.fonts.label.color = .black
                appSettings.fonts.label.background = .gray.opacity(0.3)
                appSettings.fonts.comment.color = .black
                appSettings.fonts.comment.background = .pdfComment
                appSettings.fonts.tag.color = .black
                appSettings.fonts.tag.background = .red.opacity(0.3)
            case .dark:
                appSettings.theme.foreground = .white
                appSettings.theme.foregroundMedium = .gray
                appSettings.theme.background = .black
                appSettings.fonts.title.color = .white
                appSettings.fonts.subtitle.color = .gray
                appSettings.fonts.chord.color = .red
                appSettings.fonts.label.color = .white
                appSettings.fonts.label.background = .gray
                appSettings.fonts.comment.color = .black
                appSettings.fonts.comment.background = .orange
                appSettings.fonts.tag.color = .white
                appSettings.fonts.tag.background = .red.opacity(0.5)
            case .random:
                appSettings.theme.foreground = .randomDark
                appSettings.theme.foregroundMedium = .randomDark
                appSettings.theme.background = .randomLight
                appSettings.fonts.title.color = .randomDark
                appSettings.fonts.subtitle.color = .randomDark
                appSettings.fonts.label.color = .randomDark
                appSettings.fonts.label.background = .randomLight
                appSettings.fonts.chord.color = .randomDark
                appSettings.fonts.comment.color = .randomDark
                appSettings.fonts.comment.background = .randomLight
                appSettings.fonts.tag.color = .randomDark
                appSettings.fonts.tag.background = .randomLight
            }
            return appSettings
        }
    }

    /// Export the style to JSON
    var exportToJSON: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let encodedData = try encoder.encode(self)
            return String(data: encodedData, encoding: .utf8) ?? "error"
        } catch {
            /// This should not happen
            return "error"
        }
    }
}

extension AppSettings.Style {

    /// The theme structure
    struct Theme: Codable, Equatable {
        /// The foreground color
        var foreground: Color = .black
        /// The light foreground color
        var foregroundLight: Color = .gray
        /// The medium foreground color
        var foregroundMedium: Color = .gray
        /// The background color
        var background: Color = .white
    }
}

extension AppSettings.Style {

    /// The fonts structure
    struct Fonts: Codable, Equatable {
        /// {title ...}
        var title: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 18)
        /// {subtitle ...}
        var subtitle: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 16)
        /// General text inside verse, chorus etc...
        var text: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 12)
        /// The chords, like [G7] for example
        var chord: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 10, color: .accent)
        /// The label in front of an ``ChordPro/Environment``
        var label: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 10, background: .gray.opacity(0.3))
        /// {comment ...}
        var comment: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 8, background: .pdfComment)
        /// {tag ...}
        var tag: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 8, background: .red.opacity(0.3))
        /// {textblock} environment
        var textblock: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 10, color: .gray)
    }
}
