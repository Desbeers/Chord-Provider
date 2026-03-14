//
//  ChordDefinition+init.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    // MARK: Init with all known values

    /// Init the ``ChordDefinition`` with all known values
    public init(
        id: UUID,
        frets: [Int],
        fingers: [Int],
        baseFret: Chord.BaseFret,
        root: Chord.Root,
        quality: Chord.Quality,
        slash: Chord.Root?,
        instrument: Chord.Instrument,
        kind: Kind = .customChord
    ) {
        self.id = id
        self.frets = frets
        self.fingers = fingers
        self.baseFret = baseFret
        self.root = root
        self.quality = quality
        self.slash = slash
        self.instrument = instrument
        self.kind = kind
    }

    // MARK: Init with a **ChordPro** definition

    /// Init the ``ChordDefinition`` with a **ChordPro** definition
    /// - Parameters:
    ///   - definition: The **ChordPro** definition
    ///   - kind: The ``Kind`` of ``ChordDefinition``
    ///   - instrument: The ``Chord/Instrument`` for this definition
    public init(
        definition: String,
        kind: Kind,
        instrument: Chord.Instrument,
    ) throws {
        /// Parse the chord definition
        do {
            let definition = try ChordDefinition.define(from: definition, instrument: instrument)
            /// Set the properties
            self.id = UUID()
            self.frets = definition.frets
            self.fingers = definition.fingers
            self.baseFret = definition.baseFret
            self.root = definition.root
            self.quality = definition.quality
            self.slash = definition.slash
            self.instrument = instrument
            self.kind = kind
        } catch {
            throw error
        }
    }

    // MARK: Init with a name

    /// Init the ``ChordDefinition`` with the name of a chord
    ///
    /// - Parameters:
    ///   - name: The name of the chord, e.g 'Am7'
    ///   - instrument: The ``Chord/Instrument`` for this definition
    public init?(name: String, chords: [ChordDefinition]) {
        /// Parse the chord name
        let elements = ChordUtils.Analizer.findChordElements(chord: name)
        // /// Get the chords for the instrument
        // let chords = ChordUtils.getAllChordsForInstrument(instrument: instrument.type)
        /// See if we can find it
        guard
            let root = elements.root,
            let quality = elements.quality,
            let chord = chords.matching(root: root).matching(quality: quality).matching(slash: elements.slash).first
        else {
            return nil
        }
        /// Set the properties
        self.id = chord.id
        self.frets = chord.frets
        self.fingers = chord.fingers
        self.baseFret = chord.baseFret
        self.root = chord.root
        self.quality = chord.quality
        self.slash = elements.slash
        self.instrument = chord.instrument
        self.kind = .standardChord
    }

    // MARK: Init with a ChordPro JSON chord

    /// Init the ``ChordDefinition`` with a  **ChordPro** JSON chord
    ///
    /// - Parameters:
    ///   - chord: The **ChordPro** JSON chord
    ///   - instrument: The ``Chord/Instrument`` for this definition
    public init?(chord: ChordPro.Instrument.Chord, instrument: Chord.Instrument) {
        do {
            let definition = try ChordDefinition.define(from: chord, instrument: instrument)
            /// Set the properties
            self.id = definition.id
            self.frets = definition.frets
            self.fingers = definition.fingers
            self.baseFret = definition.baseFret
            self.root = definition.root
            self.quality = definition.quality
            self.slash = definition.slash
            self.instrument = definition.instrument
            self.kind = .standardChord
        } catch {
            return nil
        }
    }

    // MARK: Init with text

    /// Init the ``ChordDefinition`` with a text instead of a chord
    ///
    /// - Parameters:
    ///   - text: The name of the text chord
    ///   - kind: The ``Kind`` of ``ChordDefinition``
    ///   - instrument: The ``Chord/Instrument`` for this definition
    ///
    /// This might be *true* text like in a grid (`*Label`) or an unknown chord
    public init(
        text: String,
        kind: Kind,
        instrument: Chord.Instrument
    ) {
        /// Set the properties
        self.id = UUID()
        self.plain = text
        self.frets = Array(repeating: 0, count: instrument.strings.count)
        self.fingers = Array(repeating: 0, count: instrument.strings.count)
        self.baseFret = .one
        self.root = .none
        self.quality = .none
        self.slash = nil
        self.instrument = instrument
        self.kind = kind
    }

    // MARK: Init an empty C chord for the diagram editor

    public init(instrument: Chord.Instrument) {
        /// Set the properties
        self.id = UUID()
        self.frets = Array(repeating: 0, count: instrument.strings.count)
        self.fingers = Array(repeating: 0, count: instrument.strings.count)
        self.baseFret = .one
        self.root = .c
        self.quality = .major
        self.slash = nil
        self.instrument = instrument
        self.kind = .customChord
    }
}
