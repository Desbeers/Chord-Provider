//
//  Chord+Component.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen

import Foundation

extension Chord {

    /// The structure of a chord component
    struct Component: Identifiable, Hashable, Sendable {
        /// The unique ID
        var id = UUID()
        /// The note
        let note: Chord.Root
        /// The MIDI note value
        let midi: Int?
        /// The name and octave
        var nameAndOctave: String? {
            if let midi {
                let octave = (midi / 12) - 1
                return "\(note.display)\(octave)"
            }
            return nil
        }
    }
}
