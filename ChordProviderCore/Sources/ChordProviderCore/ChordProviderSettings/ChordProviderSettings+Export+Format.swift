//
//  ChordProviderSettings+Export+Format.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProviderSettings.Export {

    public enum Format: String, Equatable, Codable, Sendable {
        case html
        case json
        case chordPro = "chordpro"
        case pdf
    }
}
