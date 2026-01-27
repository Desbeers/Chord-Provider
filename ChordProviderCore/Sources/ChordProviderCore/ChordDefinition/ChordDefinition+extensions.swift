//
//  ChordDefinition+extensions.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// The name of the chord for internal use
    /// - Returns: A string with the name and transpose value of the chord
    public var name: String {
        var name = self.root.rawValue + self.quality.rawValue
        if let slash = self.slash {
            name += "/\(slash.rawValue)"
        }
        name += "-\(transposed)"
        return name
    }

    /// Format the name of the chord for display
    /// - Returns: A formatted string with the name of the chord
    public var display: String {
        var name: String = ""
        if self.root == .none || self.quality == .none {
            /// We don't know anything about this chord; so use the plain name
            name = self.plain
        } else {
            name = self.root.display + self.quality.display
            if let slash = self.slash {
                name += "/\(slash.display)"
            }
        }
        return name
    }

    /// Format the name of the chord with a flat version for display
    /// - Returns: A formatted string with the flat name of the chord
    public var displayFlatForSharp: String {
        var name: String = ""
        if self.root == .none || self.quality == .none {
            /// We don't know anything about this chord; so use the plain name
            name = self.plain
        } else {
            name = self.root.swapSharpForFlat.display + self.quality.display
            if let slash = self.slash {
                name += "/\(slash.display)"
            }
        }
        return name
    }
}

extension ChordDefinition {

    /// Try to validate a ``ChordDefinition``
    public var validate: ChordDefinition.Status {
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

    /// Convert a ``ChordDefinition`` into a **ChordPro** `{define}`
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
        return define
    }
}

extension ChordDefinition {

    /// Mirror `Barres` for a left-handed chord
    mutating public func mirrorChordDiagram() {
        let strings = self.instrument.strings.count
        self.frets = self.frets.reversed()
        self.fingers = self.fingers.reversed()
        self.components = self.components.reversed()
        if let barres = self.barres {
            self.barres = barres.map { barre in
                return Chord.Barre(
                    finger: barre.finger,
                    fret: barre.fret,
                    startIndex: strings - barre.endIndex,
                    endIndex: strings - barre.startIndex
                )
            }
        }
        /// Mark the definition as mirrored
        self.mirrored = true
    }

    /// Mirror `Barres` for a left-handed chord
    /// - Returns: A mirrored ``ChordDefinition``
    public func mirroredDiagram() -> ChordDefinition {
        var copy = self
        copy.mirrorChordDiagram()
        return copy
    }
}

extension ChordDefinition {

    /// Add calculated values to a ``ChordDefinition``
    mutating public func addCalculatedValues() {
        self.transposedName = self.name
        getComponents()
        getBarres()
    }

    mutating func getComponents() {
        self.components = ChordUtils.fretsToComponents(
            root: root,
            frets: frets,
            baseFret: baseFret,
            instrument: instrument
        )
    }

    mutating func getBarres() {
        self.barres = ChordUtils.fingersToBarres(
            frets: frets,
            fingers: fingers
        )
    }
}
