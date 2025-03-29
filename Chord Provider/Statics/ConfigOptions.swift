//
//  FontStyle.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

enum ConfigOptions {
    // Just a placeholder
}

extension ConfigOptions {

    struct FontOptions: Codable, Equatable {
        var fontFamily: String = "SF Pro"
        var font: String = "SFPro-Regular"
        var size: Double = 10
        var color: Color = .primary
        var background: Color = .white

        /// The calculated `NSFont`
        var nsFont: NSFont {
            NSFont(name: font, size: size) ?? NSFont.systemFont(ofSize: size)
        }
    }
}

extension ConfigOptions {

    enum FontWeight: String, CaseIterable, Codable, Sendable {
        case normal = "Normal"
        case italic = "Italic"
        case bold = "Bold"
        case boldItalic = "Bold Italic"
        /// The *body* font with its style
        var body: Font {
            switch self {
            case .normal:
                return .system(.body)
            case .italic:
                return .system(.body).italic()
            case .bold:
                return .system(.body).bold()
            case .boldItalic:
                return .system(.body).bold().italic()
            }
        }
    }
}

extension ConfigOptions {

    enum FontStyle: String, CaseIterable, Codable, Sendable {
        /// Use a monospaced font
        case monospaced = "Monospaced"
        /// Use a serif font
        case serif = "Serif"
        /// Use a sans-serif font
        case sansSerif = "Sans Serif"
        /// The *body* font with its style
        var body: Font {
            switch self {
            case .monospaced:
                return .system(.body, design: .monospaced)
            case .serif:
                return .system(.body, design: .serif)
            case .sansSerif:
                return .system(.body, design: .default)
            }
        }
    }
}
