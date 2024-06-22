//
//  ChordProEditor+Settings.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {
    // MARK: Settings for the editor

    /// Settings for the editor
    struct Settings: Equatable, Codable, Sendable {

        // MARK: Fonts

        /// The range of available font sizes
        static let fontSizeRange: ClosedRange<Double> = 10...24

        /// The size of the font
        var fontSize: Double = 14

        // MARK: Colors (codable with an extension)

        /// The color for brackets
        var bracketColor: Color = .gray
        /// The color for a chord
        var chordColor: Color = .red
        /// The color for a directive
        var directiveColor: Color = .blue
        /// The color for a definition
        var definitionColor: Color = .teal
    }
}
