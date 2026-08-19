//
//  ChordProviderSettings+Export+Format.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordProviderSettings.Export {

    /// The export file format
    public enum Format: String, Equatable, Codable, Sendable {
        /// JSON format
        case json
        /// ChordPro format
        case chordPro = "chordpro"
        /// PDF format
        case pdf
    }
}
