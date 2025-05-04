//
//  ChordDefinition+extensions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension ChordDefinition {

    /// Get the name of the chord for internal use
    /// - Returns: A string with the name of the chord
    var getName: String {
        var name = self.root.rawValue + self.quality.rawValue
        if let slash = self.slash {
            name += "/\(slash.rawValue)"
        }
        return name
    }

    /// Format the name of the chord for display
    /// - Returns: A formatted string with the name of the chord
    var display: String {
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
    var displayFlatForSharp: String {
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
    var validate: Chord.Status {
        Analizer.validateChord(chord: self)
    }
}

extension ChordDefinition {

    /// Convert a ``ChordDefinition`` into a **ChordPro** `{define}`
    var define: String {
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

    /// Mirror a `Barre` for a left-handed chord
    /// - Parameter barre: The original barre
    /// - Returns: The left-handed barre
    func mirrorBarre(_ barre: Chord.Barre) -> Chord.Barre {
        let strings = instrument.strings.count
        return Chord.Barre(
            finger: barre.finger,
            fret: barre.fret,
            startIndex: strings - barre.endIndex,
            endIndex: strings - barre.startIndex
        )
    }
}

extension ChordDefinition {

    /// Add calculated values to a ``ChordDefinition``
    /// - Parameter instrument: The ``Instrument`` to use
    mutating func addCalculatedValues(instrument: Instrument) {
        self.components = Utils.fretsToComponents(
            root: root,
            frets: frets,
            baseFret: baseFret,
            instrument: instrument
        )
        self.barres = Utils.fingersToBarres(frets: frets, fingers: fingers)
    }
}
