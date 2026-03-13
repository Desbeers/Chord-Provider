//
//  Chord+Instrument.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation
import RegexBuilder

extension Chord {

    public struct Instrument: Codable, Sendable, Hashable {

        public init(type: InstrumentType, description: String, tuning: [String]) {
            self.type = type
            self.description = description
            self.tuning = tuning.compactMap(Chord.Instrument.Tuning.init)
        }

        /// The type of instrument
        public var type: InstrumentType
        /// The description of the instrument
        public var description: String
        /// The tuning of the instrument
        public var tuning: [Tuning]
    }
}

extension Chord.Instrument {

        /// String numbers based on the tuning
    public var strings: [Int] {
        // switch self.type {
        // case .ukulele:
        //     [0, 1, 2, 3]
        // case .testing:
        //     [0, 1, 2]
        // default:
        //     [0, 1, 2, 3, 4, 5]
        // }
        Array(self.tuning.indices)
        //Array(0..<tuning.count)
    }

    public struct Tuning: Codable, Sendable, Hashable {
        /// The note of the tuning
        public var note: Chord.Root
        /// The octave of the tuning
        public var octave: Int
    }

    public var offsets: [Int] {
        tuning.map { $0.midi - 41 }
    }
}

extension Chord.Instrument.Tuning {

    /// Regex for parsing a tune element
    private nonisolated(unsafe) static let regex = Regex {
        TryCapture {
            CharacterClass("A"..."G")
            Optionally { ChoiceOf { "#"; "b" } }
        } transform: { Chord.Root($0) }

        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
    }

    /// Init the instrument tuning
    /// - Parameter scientificPitch: The pich element
    init?(scientificPitch: String) {
        guard let match = scientificPitch.wholeMatch(of: Self.regex) else { return nil }
        (note, octave) = (match.1, match.2)
    }
}

extension Chord.Instrument.Tuning {

    /// MIDI note number
    public var midi: Int {
        let pitchClass = note.value
        return pitchClass + (octave + 1) * 12
    }
}
