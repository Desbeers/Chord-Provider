//
//  ChordDefinition+display.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordDefinition {


    /// Display the name of the ``ChordDefinition``
    ///
    /// - Returns: A formatted string with the name of the chord
    public var display: String {
        if root == .unknown || quality == .unknown {
            /// We don't know anything about this chord; so use the plain name
            return plain
        }
        var name = root.display + quality.display
        if let slash {
            name += "/\(slash.display)"
        }
        return name
    }

    /// Display the name of the ``ChordDefinition`` with optional sharp and flat combined
    ///
    /// - Returns: A formatted string with the name of the chord
    public var displayNaturalOrAccidentals: String {
        var name: String = root.display
        if root == .unknown || quality == .unknown {
            /// We don't know anything about this chord; so use the plain name
            return plain
        }
        if let shadow = root.swapSharpAndFlat {
            name += shadow.display
            if quality != .major {
                name += "\u{200A}"
            }
        }
        name += quality.display
        if let slash {
            name += "/\(slash.display)"
        }
        return name
    }

    /// Display all notes of the ``ChordDefinition`` as a single string
    public var displayAllNotes: String {
        if let elements = self.noteCombinations.first {
            let notes = elements.map { $0.required ? "<b>\($0.note.display)</b>" : $0.note.display }
            return "<b>\(self.display)</b> contains \(notes.joined(separator: ", "))"
        }
        // This should not happen
        return ""
    }

    /// Display the intervals of the ``ChordDefinition`` as a string
    public var displayIntervals: String {
        quality.intervals.intervals.map(\.description).joined(separator: ", ")
    }

    /// Display a tooltip for the ``ChordDefinition``
    ///
    /// - Note: A known chord has no tooltip.
    public var displayToolTip: String {
        self.knownChord ? "" : self.kind.description
    }
}
