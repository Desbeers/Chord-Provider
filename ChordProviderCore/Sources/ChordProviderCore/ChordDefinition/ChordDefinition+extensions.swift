//
//  ChordDefinition+extensions.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// The name of the chord
    /// - Returns: A string with the name in plain text
    public var name: String {
        var name = root.rawValue + quality.rawValue
        if let slash {
            name += "/\(slash.rawValue)"
        }
        return name
    }

    /// Format the name of the chord for display
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

    /// Format the name of the chord for display with optional sharp and flat combined
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
}

extension ChordDefinition {

    /// Try to validate a ``ChordDefinition``
    public var validate: [ChordDefinition.Status]? {
        ChordUtils.Analizer.validateChord(chord: self)
    }
}

extension ChordDefinition {

    /// Get all possible note combinations for a ``ChordDefinition``
    /// - Returns: An array with ``Chord/Note`` arrays
    public var noteCombinations: [[Chord.Note]] {
        ChordUtils.Analizer.noteCombinations(chord: self)
    }
}

extension ChordDefinition {

    /// Convert a ``ChordDefinition`` into a **ChordPro** `{define}` directive
    public var define: String {
        var define = root.rawValue
        define += quality.rawValue
        if let slash {
            define += "/\(slash.rawValue)"
        }
        define += " base-fret "
        define += String(baseFret.rawValue)
        define += " frets "
        for fret in frets {
            define += "\(fret == -1 ? "x" : fret.description) "
        }
        define += "fingers"
        for finger in fingers {
            define += " \(finger)"
        }
        return "{define-\(instrument.kind.rawValue): \(define)}"
    }
}

extension ChordDefinition {

    /// Mirror the definition for a left-handed chord
    mutating public func mirrorChordDiagram() {
        self.frets = self.frets.reversed()
        self.fingers = self.fingers.reversed()
        self.mirrored = true
    }

    /// Mirror the definition for a left-handed chord
    /// - Returns: A mirrored ``ChordDefinition``
    public func mirroredDiagram() -> ChordDefinition {
        var copy = self
        copy.mirrorChordDiagram()
        return copy
    }
}

extension ChordDefinition {

    /// Find the enharmonic equivalent of an accidental chord
    /// - Parameter chordDefinitions: All known chord definitions
    /// - Returns: The enharmonic equivalent, if found
    public func enharmonicEquivalent(in chordDefinitions: [ChordDefinition]) -> ChordDefinition? {
        if root.accidental != .natural, let equivalentRoot = root.swapSharpAndFlat {
            var copy = self
            copy.root = equivalentRoot
            return chordDefinitions.first { $0.define == copy.define }
        }
        return nil
    }
}
