//
//  ChordDefinition+init.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    // MARK: Init with a **ChordPro** definition

    /// Init the ``ChordDefinition`` with a **ChordPro** definition
    /// - Parameters:
    ///   - definition: The **ChordPro** definition
    ///   - kind: The ``Kind`` of ``ChordDefinition``
    ///   - instrument: The ``Instrument`` for this definition
    public init(
        definition: String,
        kind: Kind,
        instrument: Instrument,
    ) throws {
        /// Parse the chord definition
        do {
            self = try ChordDefinition.define(from: definition, instrument: instrument)
        } catch {
            throw error
        }
    }

    // MARK: Init with a name

    /// Init the ``ChordDefinition`` with the name of a chord
    ///
    /// - Parameters:
    ///   - name: The name of the chord, e.g 'Am7'
    ///   - instrument: The ``Chord/Instrument`` for this definition if found in the database
    public init?(name: String, chords: [ChordDefinition]) {
        /// Parse the chord name
        let elements = ChordUtils.Analizer.findChordElements(chord: name)
        /// See if we can find it
        guard
            let root = elements.root,
            let quality = elements.quality,
            let chord = chords.matching(root: root).matching(quality: quality).matching(slash: elements.slash).first
        else {
            return nil
        }
        /// Set the properties
        self = chord
    }

    // MARK: Init with a ChordPro JSON chord

    /// Init the ``ChordDefinition`` with a  **ChordPro** JSON chord
    ///
    /// - Parameters:
    ///   - chord: The **ChordPro** JSON chord
    ///   - instrument: The ``Instrument`` for this definition
    public init(chord: ChordPro.Instrument.Chord, instrument: Instrument) throws(ChordDefinition.Status) {
        do {
            self = try ChordDefinition.define(from: chord, instrument: instrument)
        } catch {
            throw error
        }
    }

    // MARK: Init with text

    /// Init the ``ChordDefinition`` with a text instead of a chord
    ///
    /// - Parameters:
    ///   - text: The name of the text chord
    ///   - kind: The ``Kind`` of ``ChordDefinition``
    ///   - instrument: The ``Instrument`` for this definition
    ///
    /// This might be *true* text like in a grid (`*Label`) or an unknown chord
    public init(
        text: String,
        kind: Kind,
        instrument: Instrument
    ) {
        self.init(
            id: UUID(),
            plain: text,
            frets: Array(repeating: 0, count: instrument.strings.count),
            fingers: Array(repeating: 0, count: instrument.strings.count),
            baseFret: .one,
            root: .none,
            quality: .none,
            slash: nil,
            instrument: instrument,
            kind: kind,
            status: kind == .textChord ? .text : .unknownChord(chord: text)
        )
    }

    // MARK: Init an empty C chord for the diagram editor

    /// Init with an empty `C`
    /// - Parameter instrument: The ``Instrument`` for this definition
    public init(instrument: Instrument) {
        self.init(
            id: UUID(),
            frets: Array(repeating: -1, count: instrument.strings.count),
            fingers: Array(repeating: 0, count: instrument.strings.count),
            baseFret: .one,
            root: .c,
            quality: .major,
            slash: nil,
            instrument: instrument,
            kind: .customChord,
            status: .correct
        )
    }

    /// Init with a `C`
    /// 
    /// If not found in the chords database, it will init an *empty* `C`
    /// - Parameter instrument: The ``Instrument`` for this definition
    public init(instrument: Instrument, chords: [ChordDefinition]) {
        if let chord = chords.matching(root: .c).matching(quality: .major).matching(slash: nil).matching(baseFret: .one).first {
            self = chord
        } else {
            self.init(instrument: instrument)
        }
    }
}
