//
//  ChordDefinition+extensions.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// The calculated name of the ``ChordDefinition``
    ///
    /// - Returns: A string with the name in plain text
    /// 
    /// - Note: This can be different from the name as set in the source file
    ///         because this value is contructed from the ``root``, ``quality``
    ///         and ``slash`` enum values..
    public var name: String {
        var name = root.rawValue + quality.rawValue
        if let slash {
            name += "/\(slash.rawValue)"
        }
        return name
    }

    /// Bool if the ``ChordDefinition`` is considered 'known' and can have a diagram
    public var knownChord: Bool {
        switch self.kind {
        case .standardChord, .transposedChord, .customChord:
            self.status == .correct ? true : false
        default:
            false
        }
    }

    /// The fingers you have to bar for the ``ChordDefinition``
    public var barres: [Chord.Barre]? {
        ChordUtils.fingersToBarres(
            frets: frets,
            fingers: fingers
        )
    }

    /// The components of the ``ChordDefinition``
    public var components: [Chord.Component] {
        ChordUtils.fretsToComponents(
            root: root,
            frets: frets,
            baseFret: baseFret,
            capo: capo,
            instrument: instrument
        )
    }

    /// The MIDI notes of the ``ChordDefinition``
    public var midiNotes: [Int] {
        components.compactMap { value in
            if let midi = value.midi {
                return midi
            }
            return nil
        }
    }

    /// Get all possible note combinations for a ``ChordDefinition``
    ///
    /// - Returns: An array with ``Chord/Note`` arrays
    var noteCombinations: [[Chord.Note]] {
        ChordUtils.Analizer.noteCombinations(chord: self)
    }

    /// All required and optional notes for a chord
    public var notes: [String] {
        if let elements = self.noteCombinations.first {
            return elements.map(\.note.display)
        }
        // This should not happen
        return []
    }

    /// Bool if a finger position is correct
    ///
    /// - Parameter string: The string number, from *low* to *high*
    ///
    /// - Returns: Bool if the finger position is correct
    public func correctFinger(string: Int) -> Bool {
        if let finger = fingers[safe: string], let fret = frets[safe: string] {
            return finger == 0 && (fret == -1 || fret == 0 ) ? true : finger > 0 && fret > 0 ? true : false
        }
        return true
    }

    /// Convert the ``ChordDefinition`` into a **ChordPro** `{define}` directive
    ///
    /// - Returns: The **ChordPro** `{define}` directive for the ``ChordDefinition``
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

    /// Mirror the ``ChordDefinition`` for a left-handed diagram
    mutating public func mirrorChordDiagram() {
        self.frets = self.frets.reversed()
        self.fingers = self.fingers.reversed()
    }

    /// Find the enharmonic equivalent of an accidental chord
    /// 
    /// - Examples:
    /// ```
    /// F# -> Gb
    /// Eb -> D#
    /// ```
    ///
    /// - Parameter chordDefinitions: All known chord definitions
    ///
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
