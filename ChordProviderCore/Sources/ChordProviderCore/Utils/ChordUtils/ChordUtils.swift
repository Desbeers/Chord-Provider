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

        switch instrument {
        case .guitar:
            if let database = try? JSONUtils.decode(guitarStandardETuning, struct: ChordPro.Instrument.self) {
                return importDatabase(database: database, instrument: instrument)
            }
        case .guitalele:
            if let database = try? JSONUtils.decode(guitaleleStandardATuning, struct: ChordPro.Instrument.self) {
                return importDatabase(database: database, instrument: instrument)
            }
        case .ukulele:
            if let database = try? JSONUtils.decode(ukuleleStandardGTuning, struct: ChordPro.Instrument.self) {
                return importDatabase(database: database, instrument: instrument)
            }
        }
        /// This should not happen
        return []
    }

    /// Import a database with chord definitions
    /// - Parameter database: The ``ChordPro/Instrument`` to import
    /// - Parameter instrument: The ``Chord/Instrument`` to use
    /// - Returns: An array of ``ChordDefinition``
    static func importDatabase(database: ChordPro.Instrument, instrument: Chord.Instrument) -> [ChordDefinition] {
        var definitions: [ChordDefinition] = []
        /// Get all chord definitions
        for chord in database.chords where chord.copy == nil {
            if let result = ChordDefinition(chord: chord, instrument: instrument) {
                definitions.append(result)
            }
        }
        /// Get all copies of chord definitions
        for chord in database.chords where chord.copy != nil {
            if var copy = definitions.first(where: { $0.name == chord.copy }) {
                copy.name = chord.name
                copy.root = copy.root.swapSharpForFlat
                copy.id = UUID()
                definitions.append(copy)
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
    ///   - uniqueNames: Bool if the chord name should be unique, so one chord for each name
    /// - Returns: A JSON string with chord definitions in **ChordPro** format
    public static func exportToJSON(definitions: [ChordDefinition], uniqueNames: Bool) throws -> String {
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
                base: chord.baseFret,
                frets: chord.frets,
                fingers: chord.fingers,
                copy: nil
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
                base: copy.baseFret,
                frets: copy.frets,
                fingers: copy.fingers,
                copy: nil
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
            chords: uniqueNames ? chords.uniqued(by: \.name) : chords,
            pdf: .init(diagrams: .init(vcells: 6))
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
        baseFret: Int,
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
                    fret += instrument.offset[string] + (fret == 0 ? 1 : baseFret) + 40
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

    /// Get all possible chord notes for a ``ChordDefinition``
    /// - Parameters chord: The ``ChordDefinition``
    /// - Returns: An array with ``Chord/Root`` arrays
    public static func getChordComponents(chord: ChordDefinition) -> [[Chord.Root]] {
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
