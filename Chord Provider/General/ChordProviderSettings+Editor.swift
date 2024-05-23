//
//  ChordProviderSettings+Editor.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordProviderSettings {

    /// Settings for the editor
    struct Editor: Equatable, Codable, Sendable {

        // MARK: Fonts

        /// The size of the font
        var fontSize: Int = 14

        // MARK: Colors

        /// - Note: Codable with an extension

        var bracketColor: Color = .gray
        var chordColor: Color = .red
        var directiveColor: Color = .blue
        var definitionColor: Color = .teal
    }
}
