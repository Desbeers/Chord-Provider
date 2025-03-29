//
//  AppSettings+PDF.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension AppSettings {

    /// Settings for displaying a PDF
    struct PDF: Codable, Equatable {
        /// Theme
        var theme: Theme = Theme()
        /// Fonts
        var fonts: Fonts = Fonts()
    }
}

extension AppSettings.PDF {
    enum Preset {
        case light
        case dark
        case random
        func presets(settings: AppSettings.PDF) -> AppSettings.PDF {
            var appSettings = settings
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

extension AppSettings.PDF {

    struct Theme: Codable, Equatable {
        var foreground: Color = .black
        var foregroundLight: Color = .gray
        var foregroundMedium: Color = .gray
        var background: Color = .white
    }
}

extension AppSettings.PDF {

    struct Fonts: Codable, Equatable {

        var title: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 18)
        var subtitle: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 16)
        var text: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 12)
        var chord: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 10, color: .accent)
        var label: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 10, background: .gray.opacity(0.3))
        var comment: ConfigOptions.FontOptions = ConfigOptions.FontOptions(size: 8, background: .pdfComment)
    }
}
