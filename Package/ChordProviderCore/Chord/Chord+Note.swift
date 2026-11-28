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

        /// Init the ``Chord/Note``
        /// - Parameters:
        ///   - note: The note
        ///   - required: Bool if the note is required
        ///   - octave: The octave number
        public init(note: Chord.Root, required: Bool = true, octave: Int = 0) {
            self.note = note
            self.required = required
            self.octave = octave
        }

        /// Identifiable protocol
        public var id: String {
            display
        }
        /// The note
        public var note: Chord.Root
        /// Bool if the note is required
        public var required: Bool
        /// The octave number
        public let octave: Int
        /// The note for display, like `C3`
        public var display: String {
            "\(note.display)\(octave)"
        }
    }
}
