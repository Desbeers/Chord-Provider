//
//  AppSettings+Style.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension AppSettings {

    /// Settings for displaying a song
    struct Style: Codable, Equatable {
        /// Theme
        var theme: Theme = Theme()
        /// Fonts
        var fonts: Fonts = Fonts()
    }
}

extension AppSettings.Style {
    enum Preset {
        case light
        case dark
        case random
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

    struct Theme: Codable, Equatable {
        var foreground: Color = .black
        var foregroundLight: Color = .gray
        var foregroundMedium: Color = .gray
        var background: Color = .white
    }
}

extension AppSettings.Style {

    struct Fonts: Codable, Equatable {

        var title: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 18)
        var subtitle: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 16)
        var text: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 12)
        var chord: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 10, color: .accent)
        var label: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 10, background: .gray.opacity(0.3))
        var comment: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 8, background: .pdfComment)
        var tag: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 8, background: .red.opacity(0.3))
        var textblock: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 10, color: .gray)
    }
}
