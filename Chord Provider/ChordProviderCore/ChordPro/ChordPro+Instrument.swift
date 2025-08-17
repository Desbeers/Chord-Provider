//
//  ChordPro+Instrument.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro {

    /// A **ChordPro** Instrument
    struct Instrument: Codable {
        /// The instrument
        let instrument: Instrument
        /// The tuning of the instrument
        let tuning: [String]
        /// The chords for the instrument
        let chords: [Chord]
        /// PDF settings for the instrument
        let pdf: PDF
    }
}

extension ChordPro.Instrument {

    /// Instrument chord
    struct Chord: Equatable, Codable {
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
        /// Optional copy of another chord
        let copy: String?
    }

    /// The instrument
    struct Instrument: Codable {
        /// The description of the instrument
        let description, type: String
    }

    /// PDF settings for the instrument
    struct PDF: Codable {
        /// PDF diagram settings
        let diagrams: Diagrams
    }

    /// Diagram settings for the instrument
    struct Diagrams: Codable {
        /// Amount of frets
        let vcells: Int
    }
}
