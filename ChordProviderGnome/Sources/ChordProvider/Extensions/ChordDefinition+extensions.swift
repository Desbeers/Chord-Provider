//
//  ChordDefinition+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import ChordProviderCore

extension ChordDefinition {

    /// Make a String with all the notes in a chord
    public var notesLabel: String {
        if let elements = self.noteCombinations.first {
            let notes = elements.map { $0.required ? "<b>\($0.note.display)</b>" : $0.note.display }
            return "<b>\(self.display)</b> contains \(notes.joined(separator: ", "))"
        }
        /// This should not happen
        return ""
    }
}
