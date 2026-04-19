//
//  ChordDefinition+extensions.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// The name of the chord
    /// - Returns: A string with the name in plain text
    public var name: String {
        var name = root.rawValue + quality.rawValue
        if let slash = slash {
            name += "/\(slash.rawValue)"
        }
        return name
    }

    /// Format the name of the chord for display
    /// - Returns: A formatted string with the name of the chord
    public var display: String {
        var name: String = ""
        if root == .none || quality == .none {
            /// We don't know anything about this chord; so use the plain name
            name = plain
        } else {
            name = root.display + quality.display
            if let slash = slash {
                name += "/\(slash.display)"
            }
        }
        return name
    }

    /// Format the name of the chord for display with sharp and flat combined
    /// - Returns: A formatted string with the name of the chord
    public var displaySharpAndFlat: String {
        var name: String = ""
        if root == .none || quality == .none {
            /// We don't know anything about this chord; so use the plain name
            name = plain
        } else {
            let spacer = root.accidental == .natural ? "" : " "
            name = "\(root.naturalAndSharpDisplay)\(spacer)\(quality.display)"
            if let slash = slash {
                name += "/\(slash.display)"
            }
        }
        return name
    }

    /// Format the name of the chord with a flat version for display
    /// - Returns: A formatted string with the flat name of the chord
    public var displayFlatForSharp: String {
        var name: String = ""
        if root == .none || quality == .none {
            /// We don't know anything about this chord; so use the plain name
            name = plain
        } else {
            name = root.swapSharpForFlat.display + quality.display
            if let slash = slash {
                name += "/\(slash.display)"
            }
        }
        return name
    }
}

extension ChordDefinition {

    /// Try to validate a ``ChordDefinition``
    public var validate: [ChordDefinition.Status] {
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

    /// Find the flat version of a sharp chord
    /// - Parameter chords: All the known chords
    /// - Returns: A flat version, if found
    public func findFlatFromSharp(chords: [ChordDefinition]) -> ChordDefinition? {
        var copy = self
        if copy.root.accidental == .sharp {
            copy.root = copy.root.swapSharpForFlat
            return chords.first(where: { $0.define == copy.define })
        }
        return nil
    }
}
