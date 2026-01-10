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
        var result = ""
        if let elements = self.noteCombinations.first {
            result = "<b>\(self.display)</b> contains \(elements.map { $0.required ? "<b>\($0.note.display)</b>" : $0.note.display } .joined(separator: ", "))"
        }
        return result
    }
}
