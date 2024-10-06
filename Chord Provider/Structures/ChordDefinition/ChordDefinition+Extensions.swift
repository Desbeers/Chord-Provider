//
//  ChordDefinition+Extensions.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordDefinition {

    /// Format the name of the chord for display
    /// - Parameter options: The ``DisplayOptions``
    /// - Returns: A formatted string with the name of the chord
    var displayName: String {
        var name: String = ""
        if self.status == .unknownChord || self.quality == .unknown {
            /// We don't know anything about this chord; so use the original name
            name = self.name
        } else {
            name = self.root.display + self.quality.display
            if let bass = self.bass {
                name += "/\(bass.display)"
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
        if let bass {
            define += "/\(bass.rawValue)"
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

    /// Play a ``ChordDefinition`` with MIDI
    /// - Parameter instrument: The `instrument` to use
    func play(instrument: Midi.Instrument = .acousticNylonGuitar) {
        Task {
            await MidiPlayer.shared.playChord(notes: self.components.compactMap(\.midi), instrument: instrument)
        }
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
