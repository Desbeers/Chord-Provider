//
//  Instrument.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation
import RegexBuilder

extension Instrument {

    public struct Tuning: Codable, Sendable, Hashable, Identifiable, CustomStringConvertible {

        /// Init the instrument tuning with known values
        /// - Parameters:
        ///   - note: The note of the tuning
        ///   - value: The octave of the tuning
        ///
        public init(note: Chord.Root, octave: Int) {
            self.note = note
            self.octave = octave
        }

        /// Identifiable protocol
        public var id: Self { self }

        /// CustomStringConvertible protocol
        public var description: String {
            "\(note.rawValue)\(octave)"
        }

        /// The note of the tuning
        public var note: Chord.Root
        /// The octave of the tuning
        public var octave: Int
    }
}

extension Instrument.Tuning {

    /// Init the instrument tuning with a string
    ///
    /// For example: "E2"
    /// - Parameter scientificPitch: The pitch element
    init?(scientificPitch: String) {
        guard let match = scientificPitch.wholeMatch(of: RegexDefinitions.tune) else { return nil }
        (note, octave) = (match.1, match.2)
    }
}

extension Instrument.Tuning {

    /// MIDI note number
    public var midi: Int {
        let pitchClass = note.value
        return pitchClass + (octave + 1) * 12
    }
}
