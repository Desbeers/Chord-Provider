//
//  FontConfig.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// Configuration options for a font
/// - Note: a *font* is not like a `Font`; it is more like a *directive font* like `title`
enum FontConfig: String, CaseIterable {
    /// {title ...}
    case title = "Title"
    /// {subtitle ...}
    case subtitle = "Subtitle"
    /// General text inside verse, chorus etc...
    case text = "Text"
    /// The chords, like [G7] for example
    case chord = "Chords"
    /// The label in front of an ``ChordPro/Environment``
    case label = "Labels"
    /// {comment ...}
    case comment = "Comments"
    /// {tag ...}
    case tag = "Tags"
    /// {textblock} environment
    case textblock = "Text Blocks"
    /// The available ``FontConfig/Options`` for a ``FontConfig``
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
        case .tag:
            [.font, .size, .color, .background]
        case .textblock:
            [.font, .size, .color]
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
