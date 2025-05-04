//
//  Utils.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

/// Chord utilities
enum Utils {

    /// Get index value of a note
    static func noteToValue(note: Chord.Root) -> Int {
        guard let value = Scales.noteValueDict[note] else {
            return 0
        }
        return value
    }

    /// Return note by index in a scale
    static func valueToNote(value: Int, scale: Chord.Root) -> Chord.Root {
        let value = value < 0 ? (12 + value) : (value % 12)
        guard let value = Scales.scaleValueDict[scale]?[value] else {
            return .c
        }
        return value
    }

    /// Transpose the chord
    /// - Parameters:
    ///   - transpose: Transpose key
    ///   - note: The root note
    ///   - scale: Key scale
    static func transposeNote(note: Chord.Root, transpose: Int, scale: Chord.Root = .c) -> Chord.Root {
        let value = noteToValue(note: note) + transpose
        return valueToNote(value: value, scale: scale)
    }

    /// Calculate the chord components
    static func fretsToComponents(
        root: Chord.Root,
        frets: [Int],
        baseFret: Int,
        instrument: Instrument
    ) -> [Chord.Component] {
        var components: [Chord.Component] = []
        if !frets.isEmpty {
            for string in instrument.strings {
                var fret = frets[string]
                /// Don't bother with ignored frets
                if fret == -1 {
                    components.append(Chord.Component(note: .none, midi: nil))
                } else {
                    /// Add base fret if the fret is not 0 and the offset
                    fret += instrument.offset[string] + (fret == 0 ? 1 : baseFret) + 40
                    let key = valueToNote(value: fret, scale: root)
                    components.append(Chord.Component(note: key, midi: fret))
                }
            }
        }
        return components
    }

    /// Check if fingers should be barred
    /// - Parameters:
    ///   - frets: The frets of the chord
    ///   - fingers: The fingers of the chord
    /// - Returns: An array with fingers that should be barred
    static func fingersToBarres(
        frets: [Int],
        fingers: [Int]
    ) -> [Chord.Barre] {
        var barres: [Chord.Barre] = []
        /// Map the fingers to a  key-value pair
        let mappedItems = fingers.map { finger -> (finger: Int, count: Int) in
            (finger, 1)
        }
        /// Create a dictionary with unique fingers so we get the total count for each finger
        let counts = Dictionary(mappedItems, uniquingKeysWith: +)
        /// set the barres but use not '0' as barres
        for (finger, count) in counts where count > 1 && finger != 0 {
            guard
                let firstFinger = fingers.firstIndex(of: finger),
                let lastFinger = fingers.lastIndex(of: finger),
                let fret = frets[safe: firstFinger]
            else {
                break
            }
            let barre = Chord.Barre(
                finger: finger,
                fret: fret,
                startIndex: firstFinger,
                endIndex: lastFinger + 1
            )
            /// Don't add a barre when the fingers are not correct; the first fret should never be zero
            if fret != 0 {
                barres.append(barre)
            }
        }
        /// Return the fingers that should be barred
        return barres
    }

    /// Get all possible chord notes for a ``ChordDefinition``
    /// - Parameters chord: The ``ChordDefinition``
    /// - Returns: An array with ``Chord/Root`` arrays
    static func getChordComponents(chord: ChordDefinition) -> [[Chord.Root]] {
        /// All the possible note combinations
        var result: [[Chord.Root]] = []
        /// Get the root note value
        let rootValue = noteToValue(note: chord.root)
        /// Get all notes
        let notes = chord.quality.intervals.intervals.map(\.semitones).map { tone in
            valueToNote(value: tone + rootValue, scale: chord.root)
        }
        /// Get a list of optional notes that can be omitted
        let optionals = chord.quality.intervals.optional.map(\.semitones).map { tone in
            valueToNote(value: tone + rootValue, scale: chord.root)
        }.combinationsWithoutRepetition
        /// Make all combinations
        for optional in optionals {
            var components = notes.filter { !optional.contains($0) }
            /// Add the optional slash bass
            if let slash = chord.slash, !components.values.contains(slash.value) {
                components.insert(slash, at: 0)
            }
            result.append(components)
        }
        /// Return the result
        return result
    }
}
