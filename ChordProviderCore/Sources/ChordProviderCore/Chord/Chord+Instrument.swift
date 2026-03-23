//
//  Chord+Instrument.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation
import RegexBuilder

extension Chord {

    public struct Instrument: Codable, Sendable, Hashable, Identifiable, CustomStringConvertible {

        public init(
            type: InstrumentType,
            label: String,
            tuning: [String],
            bundle: String? = nil,
            fileURL: URL? = nil,
            modified: Bool = false
        ) {
            self.type = type
            self.label = label
            self.tuning = tuning.compactMap(Chord.Instrument.Tuning.init)
            self.bundle = bundle
            self.fileURL = fileURL
            self.modified = modified
        }

        /// Identifiable protocol
        public var id: Self { self }

        /// CustomStringConvertible protocol
        public var description: String {
            var result = [type.description, label]
            if modified {
                result.append("modified")
            }
            return result.joined(separator: " · ")
        }

        /// The type of instrument
        public var type: InstrumentType
        /// The label of the instrument
        public var label: String
        /// The tuning of the instrument
        public var tuning: [Tuning]
        /// The optional path to the build-in bundle
        public var bundle: String?
        /// The optional URL to the custom definitions
        public var fileURL: URL?
        /// Bool if the database is modified
        public var modified: Bool = false
    }
}

extension Chord.Instrument {

    /// String numbers based on the tuning
    public var strings: [Int] {
        Array(self.tuning.indices)
    }

    public struct Tuning: Codable, Sendable, Hashable, Identifiable {
        /// The note of the tuning
        public var note: Chord.Root
        /// The octave of the tuning
        public var octave: Int

        /// Identifiable protocol
        public var id: Self { self }
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

    public init(note: Chord.Root, value: Int) {
        self.note = note
        self.octave = value
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
