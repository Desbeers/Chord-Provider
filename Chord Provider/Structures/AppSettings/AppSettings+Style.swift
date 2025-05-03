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
        /// Default style
        func defaults() -> Style {
            AppSettings.Style.ColorPreset.light.presets(style: AppSettings.Style())
        }
    }
}

extension AppSettings.Style {

    /// Font Presets
    enum FontPreset: String, CaseIterable {
        /// Sans
        case sans = "Sans"
        /// Serif
        case serif = "Serif"
        /// Just for fun; random fonts
        case random = "Random"

        /// Add fonts to the style settings
        /// - Parameter style: The current style
        /// - Returns: An updated style
        func presets(style: AppSettings.Style, fonts: [FontItem]) -> AppSettings.Style {

            var style = style

            guard
                let sans = fonts.first(where: { $0.postScriptName == "HelveticaNeue" }),
                let serif = fonts.first(where: { $0.postScriptName == "TimesNewRomanPSMT" })
            else {
                return style
            }

            switch self {

            case .sans:
                style.fonts.title.font = sans
                style.fonts.subtitle.font = sans
                style.fonts.text.font = sans
                style.fonts.chord.font = sans
                style.fonts.label.font = sans
                style.fonts.comment.font = sans
                style.fonts.tag.font = sans
                style.fonts.textblock.font = sans
            case .serif:
                style.fonts.title.font = serif
                style.fonts.subtitle.font = serif
                style.fonts.text.font = serif
                style.fonts.chord.font = serif
                style.fonts.label.font = serif
                style.fonts.comment.font = serif
                style.fonts.tag.font = serif
                style.fonts.textblock.font = serif
            case .random:
                style.fonts.title.font = fonts.randomElement() ?? sans
                style.fonts.subtitle.font = fonts.randomElement() ?? sans
                style.fonts.text.font = fonts.randomElement() ?? sans
                style.fonts.chord.font = fonts.randomElement() ?? sans
                style.fonts.label.font = fonts.randomElement() ?? sans
                style.fonts.comment.font = fonts.randomElement() ?? sans
                style.fonts.tag.font = fonts.randomElement() ?? sans
                style.fonts.textblock.font = fonts.randomElement() ?? sans
            }

            return style
        }
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
                style.theme.foregroundLight = Color(red: 0.89, green: 0.89, blue: 0.89)
                style.theme.background = .white
                style.fonts.title.color = .black
                style.fonts.subtitle.color = .gray
                style.fonts.chord.color = .accent
                style.fonts.label.color = .black
                style.fonts.label.background = Color(red: 0.867, green: 0.867, blue: 0.867)
                style.fonts.comment.color = .black
                style.fonts.comment.background = Color(red: 0.941, green: 0.91, blue: 0.788)
                style.fonts.tag.color = .black
                style.fonts.tag.background = Color(red: 1, green: 0.78, blue: 0.765)
                style.fonts.textblock.color = .black
            case .dark:
                style.theme.foreground = .white
                style.theme.foregroundMedium = Color(red: 0.875, green: 0.875, blue: 0.875)
                style.theme.foregroundLight = Color(red: 0.714, green: 0.714, blue: 0.714)
                style.theme.background = .black
                style.fonts.title.color = .white
                style.fonts.subtitle.color = .gray
                style.fonts.chord.color = .red
                style.fonts.label.color = .white
                style.fonts.label.background = .gray
                style.fonts.comment.color = .black
                style.fonts.comment.background = .orange
                style.fonts.tag.color = .white
                style.fonts.tag.background = Color(red: 0.498, green: 0.122, blue: 0.098)
                style.fonts.textblock.color = .white
            case .random:
                style.theme.foreground = .randomDark
                style.theme.foregroundMedium = .randomDark
                style.theme.foregroundLight = .randomDark
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
                style.fonts.textblock.color = .randomDark
            }
            style.fonts.title.color = style.theme.foreground
            style.fonts.subtitle.color = style.theme.foregroundMedium
            style.fonts.text.color = style.theme.foreground
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
        var foregroundLight: Color = Color(red: 0.89, green: 0.89, blue: 0.89)
        /// The medium foreground color
        var foregroundMedium: Color = .gray
        /// The background color
        var background: Color = .white
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            /// The foreground color
            case foreground
            /// The light foreground color
            case foregroundLight = "foreground-light"
            /// The medium foreground color
            case foregroundMedium = "foreground-medium"
            /// The background color
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
        var chord: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 10)
        /// The label in front of an ``ChordPro/Environment``
        var label: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 10)
        /// {comment ...}
        var comment: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 8)
        /// {tag ...}
        var tag: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 8)
        /// {textblock} environment
        var textblock: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 11)
    }
}
