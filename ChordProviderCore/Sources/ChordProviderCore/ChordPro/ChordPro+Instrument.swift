//
//  ChordPro+Instrument.swift
//  Chord Provider
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
        /// PDF settings for the instrument
        let pdf: PDF
    }
}

extension ChordPro.Instrument {

    /// Instrument chord
    public struct Chord: Equatable, Codable, Sendable {

        public init(name: String, display: String? = nil, base: Int? = nil, frets: [Int]? = nil, fingers: [Int]? = nil, copy: String? = nil) {
            self.name = name
            self.display = display
            self.base = base
            self.frets = frets
            self.fingers = fingers
            self.copy = copy
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
        /// Optional copy of another chord
        let copy: String?
    }

    /// The instrument
    public struct Instrument: Codable, Sendable {
        /// The description of the instrument
        let description, type: String
    }

    /// PDF settings for the instrument
    public struct PDF: Codable, Sendable {
        /// PDF diagram settings
        let diagrams: Diagrams
    }

    /// Diagram settings for the instrument
    public struct Diagrams: Codable, Sendable {
        /// Amount of frets
        let vcells: Int
    }
}
