//
//  Chord+Note.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Chord {

    /// The structure of a chord note and if the note is required
    public struct Note: Identifiable, Hashable, Sendable, Codable {
        /// Identifiable protocol
        public var id: String {
            note.rawValue
        }
        /// The note
        public var note: Chord.Root
        /// Bool if the note is reuired
        public var required: Bool
    }
}
