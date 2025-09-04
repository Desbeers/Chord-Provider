//
//  ChordDefinition+extensions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// Get the name of the chord for internal use
    /// - Returns: A string with the name of the chord
    public var getName: String {
        var name = self.root.rawValue + self.quality.rawValue
        if let slash = self.slash {
            name += "/\(slash.rawValue)"
        }
        return name
    }

    /// Format the name of the chord for display
    /// - Returns: A formatted string with the name of the chord
    public var display: String {
        var name: String = ""
        if self.status == .unknownChord || self.quality == .unknown {
            /// We don't know anything about this chord; so use the original name
            name = self.name
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
        if self.status == .unknownChord || self.quality == .unknown {
            /// We don't know anything about this chord; so use the original name
            name = self.name
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

    /// Convert a ``ChordDefinition`` into a **ChordPro** `{define}`
    public var define: String {
        var define = root.rawValue
        define += quality.rawValue
        if let slash {
            define += "/\(slash.rawValue)"
        }
        define += " base-fret "
        define += baseFret.description
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
    /// - Parameter instrument: The ``Chord/Instrument`` to use
    mutating public func addCalculatedValues(instrument: Chord.Instrument) {
        self.components = ChordUtils.fretsToComponents(
            root: root,
            frets: frets,
            baseFret: baseFret,
            instrument: instrument
        )
        self.barres = ChordUtils.fingersToBarres(frets: frets, fingers: fingers)
    }
}

extension ChordDefinition {

    var chordProJSON: ChordPro.Instrument.Chord {
        ChordPro.Instrument.Chord(
            name: name,
            display: display,
            base: baseFret,
            frets: frets,
            fingers: fingers,
            copy: nil
        )
    }
}
