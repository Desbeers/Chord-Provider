//
//  FontConfig.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

    /// Configuration options for a font
    enum FontConfig: String, CaseIterable {
        case title = "Title"
        case subtitle = "Subtitle"
        case text = "Text"
        case chord = "Chords"
        case label = "Labels"
        case comment = "Comments"
        /// The available options for a
        var options: [Options] {
            switch self {
            case .title:
                [.font, .size]
            case .subtitle:
                [.font, .size]
            case .text:
                [.font, .size]
            case .chord:
                [.font, .size, .color]
            case .label:
                [.font, .size, .color, .background]
            case .comment:
                [.font, .size, .color, .background]
            }
        }
        /// Get the color for a ``ChordPro/FontConfig``
        /// - Parameter settings: The application settings
        /// - Returns: a SwiftUI Color
        func color(settings: AppSettings) -> Color {
            switch self {
            case .title:
                settings.pdf.theme.foreground
            case .subtitle:
                settings.pdf.theme.foregroundMedium
            case .text:
                settings.pdf.theme.foreground
            case .chord:
                settings.pdf.fonts.chord.color
            case .label:
                settings.pdf.fonts.label.color
            case .comment:
                settings.pdf.fonts.comment.color
            }
        }
        /// An optional 'help' for the config
        var help: String? {
            switch self {
            case .title:
                "The color of the title is the general **foreground color**."
            case .subtitle:
                "The color of the subtitle is the general **secondary foreground color**."
            case .text:
                "The color of the text is the **general foreground color**."
            case .label:
                "The background color will only be used for a **chorus**."
            default:
                nil
            }
        }
    }

extension FontConfig {

    /// The options a font config can have
    enum Options {
        /// The font
        case font
        /// The size of the font
        case size
        /// The foreground color of the font
        case color
        /// The background color of the font
        case background
    }
}
