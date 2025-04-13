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

            var style = style

            switch self {
            case .light:
                style.theme.foreground = .black
                style.theme.foregroundMedium = .gray
                style.theme.background = .white
                style.fonts.title.color = .black
                style.fonts.subtitle.color = .gray
                style.fonts.chord.color = .accent
                style.fonts.label.color = .black
                style.fonts.label.background = .gray.opacity(0.3)
                style.fonts.comment.color = .black
                style.fonts.comment.background = .pdfComment
                style.fonts.tag.color = .black
                style.fonts.tag.background = .red.opacity(0.3)
            case .dark:
                style.theme.foreground = .white
                style.theme.foregroundMedium = .gray
                style.theme.background = .black
                style.fonts.title.color = .white
                style.fonts.subtitle.color = .gray
                style.fonts.chord.color = .red
                style.fonts.label.color = .white
                style.fonts.label.background = .gray
                style.fonts.comment.color = .black
                style.fonts.comment.background = .orange
                style.fonts.tag.color = .white
                style.fonts.tag.background = .red.opacity(0.5)
            case .random:
                style.theme.foreground = .randomDark
                style.theme.foregroundMedium = .randomDark
                style.theme.background = .randomLight
                style.fonts.title.color = .randomDark
                style.fonts.subtitle.color = .randomDark
                style.fonts.label.color = .randomDark
                style.fonts.label.background = .randomLight
                style.fonts.chord.color = .randomDark
                style.fonts.comment.color = .randomDark
                style.fonts.comment.background = .randomLight
                style.fonts.tag.color = .randomDark
                style.fonts.tag.background = .randomLight
            }
            return style
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
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case foreground
            case foregroundLight = "foreground-light"
            case foregroundMedium = "foreground-medium"
            case background
        }
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
