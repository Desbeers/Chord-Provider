//
//  Chord+Note.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord {

    /// The structure of a chord note and if the note is required
    public struct Note: Identifiable, Hashable, Sendable, Codable {
        public var id: String {
            note.rawValue
        }
        public var note: Chord.Root
        public var required: Bool
    }
}
