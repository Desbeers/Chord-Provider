//
//  ChordProviderSettings+Export.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordProviderSettings {

    /// Export settings
    public struct Export: Equatable, Codable, Sendable {
        /// The export file format
        public var format: Format = .chordPro
    }
}
