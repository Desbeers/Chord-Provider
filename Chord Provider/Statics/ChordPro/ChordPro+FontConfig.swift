//
//  ChordPro+FontConfig.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension ChordPro {

    enum FontConfig: String, CaseIterable {
        case title = "Title"
        case subtitle = "Subtitle"
        case text = "Text"
        case chord = "Chords"
        case label = "Labels"
        case comment = "Comments"

        var options: [FontOptions] {
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

        func color(settings: AppSettings.PDF) -> Color {
            switch self {
            case .title:
                settings.theme.foreground
            case .subtitle:
                settings.theme.foregroundMedium
            case .text:
                settings.theme.foreground
            case .chord:
                settings.fonts.chord.color
            case .label:
                settings.fonts.label.color
            case .comment:
                settings.fonts.comment.color
            }
        }

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

    enum FontOptions {
        case font
        case size
        case color
        case background
    }
}
