//
//  ChordPro+Instrument.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro {

    /// A **ChordPro** Instrument
    public struct Instrument: Codable, Sendable {
        /// The instrument
        let instrument: Instrument
        /// The tuning of the instrument
        let tuning: [String]
        /// The chords for the instrument
        let chords: [Chord]
    }
}

extension ChordPro.Instrument {

    /// Instrument chord
    public struct Chord: Equatable, Codable, Sendable {

        public init(name: String, display: String? = nil, base: Int? = nil, frets: [Int]? = nil, fingers: [Int]? = nil) {
            self.name = name
            self.display = display
            self.base = base
            self.frets = frets
            self.fingers = fingers
        }

        /// Name of the chord
        let name: String
        /// Optional display name
        let display: String?
        /// Base fret
        let base: Int?
        /// Frets
        let frets: [Int]?
        /// Fingers
        let fingers: [Int]?
    }

    /// The instrument
    public struct Instrument: Codable, Sendable {
        /// The description of the instrument
        let description, type: String
    }
}
