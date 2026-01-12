//
//  ChordUtils.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Utilities to handle chords
public enum ChordUtils {

    /// Get all the guitar chords in a ``ChordDefinition`` array
    static let guitar = ChordUtils.importInstrument(.guitar)

    /// Get all the guitalele chords in a ``ChordDefinition`` array
    static let guitalele = ChordUtils.importInstrument(.guitalele)

    /// Get all the ukulele chords in a ``ChordDefinition`` array
    static let ukulele = ChordUtils.importInstrument(.ukulele)

    /// Get all chord definitions for an instrument
    /// - Parameter instrument: The ``Chord/Instrument``
    /// - Returns: An ``ChordDefinition`` array
    public static func getAllChordsForInstrument(instrument: Chord.Instrument) -> [ChordDefinition] {
        switch instrument {
        case .guitar:
            ChordUtils.guitar
        case .guitalele:
            ChordUtils.guitalele
        case .ukulele:
            ChordUtils.ukulele
        }
    }

    /// Import a definition database from a JSON database file
    private static func importInstrument( _ instrument: Chord.Instrument) -> [ChordDefinition] {
        let database = Bundle.module.decode(ChordPro.Instrument.self, from: instrument.database)
        var definitions: [ChordDefinition] = []
        /// Get all chord definitions
        for chord in database.chords {
            if let result = ChordDefinition(chord: chord, instrument: instrument) {
                definitions.append(result)
            }
        }
        return definitions.sorted(
            using: [
                KeyPathComparator(\.baseFret), KeyPathComparator(\.frets.description)
            ]
        )
    }

    /// Export the definitions to a JSON string
    /// - Parameters:
    ///   - definitions: The chord definitions
    /// - Returns: A JSON string with chord definitions in **ChordPro** format
    public static func exportToJSON(definitions: [ChordDefinition]) throws -> String {
        guard
            /// The first definition is needed to find the instrument
            let instrument = definitions.first?.instrument
        else {
            throw ChordDefinition.Status.noChordsDefined
        }
        let basicAndSharps = definitions.filter { $0.root.accidental != .flat }
        var chords = basicAndSharps.map { chord in
            ChordPro.Instrument.Chord(
                name: chord.name,
                display: chord.name == chord.display ? nil : chord.display,
                base: chord.baseFret.rawValue,
                frets: chord.frets,
                fingers: chord.fingers
            )
        }
        let flats = definitions.filter { $0.root.accidental == .sharp }
        chords += flats.map { chord in
            /// Make an editable copy
            var copy = chord
            /// Swap sharp for flat
            copy.root = chord.root.swapSharpForFlat
            /// Change the name
            copy.name = "\(copy.root.rawValue)\(chord.quality.rawValue)"
            if let slash = chord.slash {
                copy.name += "/\(slash.rawValue)"
            }
            return ChordPro.Instrument.Chord(
                name: copy.name,
                display: copy.name == copy.display ? nil : copy.display,
                base: copy.baseFret.rawValue,
                frets: copy.frets,
                fingers: copy.fingers
            )
        }
        chords.sort(
            using: [
                KeyPathComparator(\.name),
                KeyPathComparator(\.base),
                KeyPathComparator(\.frets?.description)
            ]
        )
        let export = ChordPro.Instrument(
            instrument: .init(
                description: instrument.description,
                type: instrument.rawValue
            ),
            tuning: instrument.tuning,
            chords: chords
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        do {
            let encodedData = try encoder.encode(export)
            return String(data: encodedData, encoding: .utf8) ?? "error"
        } catch {
            throw ChordDefinition.Status.noChordsDefined
        }
    }

    /// Find the root, quality and optional bass of a named chord
    /// - Parameter chord: The name of the chord as `String`
    /// - Returns: The root, quality and optional slash
    public static func findChordElements(chord: String) -> (root: Chord.Root?, quality: Chord.Quality?, slash: Chord.Root?) {
        Analizer.findChordElements(chord: chord)
    }

    /// Get index value of a note
    static func noteToValue(note: Chord.Root) -> Int {
        guard let value = Chord.Scales.noteValueDict[note] else {
            return 0
        }
        return value
    }

    /// Return note by index in a scale
    public static func valueToNote(value: Int, scale: Chord.Root) -> Chord.Root {
        let value = value < 0 ? (12 + value) : (value % 12)
        guard let value = Chord.Scales.scaleValueDict[scale]?[value] else {
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
        baseFret: Chord.BaseFret,
        instrument: Chord.Instrument
    ) -> [Chord.Component] {
        var components: [Chord.Component] = []
        if !frets.isEmpty {
            for string in instrument.strings {
                var fret = frets[string]
                /// Don't bother with ignored frets
                if fret == -1 {
                    components.append(Chord.Component(id: string, note: .none, midi: nil))
                } else {
                    /// Add base fret if the fret is not 0 and the offset
                    fret += instrument.offset[string] + (fret == 0 ? 1 : baseFret.rawValue) + 40
                    let key = valueToNote(value: fret, scale: root)
                    components.append(Chord.Component(id: string, note: key, midi: fret))
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
    ) -> [Chord.Barre]? {
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
                return nil
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
        return barres.isEmpty ? nil : barres
    }
}
