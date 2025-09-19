//
//  Chord+Component.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen

import Foundation

extension Chord {

    /// The structure of a chord component
    public struct Component: Identifiable, Hashable, Sendable, Codable {
        /// The unique ID
        public var id: Int
        /// The note
        public let note: Chord.Root
        /// The MIDI note value
        public let midi: Int?
        /// The name and octave
        public var nameAndOctave: String? {
            if let midi {
                let octave = (midi / 12) - 1
                return "\(note.display)\(octave)"
            }
            return nil
        }
    }
}
