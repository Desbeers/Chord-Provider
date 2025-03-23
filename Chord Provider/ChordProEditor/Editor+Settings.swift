//
//  Editor+Settings.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension Editor {

    // MARK: Settings for the editor

    /// Settings for the editor
    struct Settings: Equatable, Codable, Sendable {

        // MARK: Fonts

        /// The range of available font sizes
        static let fontSizeRange: ClosedRange<Double> = 10...24

        /// The size of the font
        var fontSize: Double = 14

        /// The font style of the editor
        var fontStyle: ConfigOptions.FontStyle = .monospaced

        /// The calculated font for the editor
        var font: NSFont {
            return ConfigOptions.FontOptions(
                size: fontSize
            ).nsFont
        }

        // MARK: Colors (codable with an extension)

        /// The color for brackets
        var bracketColor: Color = .gray
        /// The color for a chord
        var chordColor: Color = .red
        /// The color for a directive
        var directiveColor: Color = .indigo
        /// The color for a directive argument
        var argumentColor: Color = .orange
        /// The color for markup
        var markupColor: Color = .teal
        /// The color for comments
        var commentColor: Color = .gray
    }
}
