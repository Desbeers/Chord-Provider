//
//  ChordProviderSettings+Export+Format.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordProviderSettings.Export {

    public enum Format: String, Equatable, Codable, Sendable {
        case json
        case chordPro = "chordpro"
        case pdf
    }
}
