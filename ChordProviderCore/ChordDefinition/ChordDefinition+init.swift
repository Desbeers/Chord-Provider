//
//  ChordDefinition+init.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// Init a Chord Definition with the name of a chord as plain text
    ///
    /// - Parameters:
    ///   - name: The name of the chord, e.g 'Am7'
    ///   - chords: All the known chords
    public init?(name: String, chords: [ChordDefinition]) {
        // The elements of the chord definition
        let elements = ChordUtils.Analizer.findChordElements(chord: name)
        // See if we can find it in the list of known chords
        guard
            let root = elements.root,
            let quality = elements.quality,
            let chord = chords.matching(root: root).matching(quality: quality).matching(slash: elements.slash).first
        else {
            return nil
        }
        // Set the properties of the chord definition
        self = chord
    }

    /// Init a Chord Definition with a text instead of a chord
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
        instrument: Instrument = Instrument[.guitar]
    ) {
        self.init(
            id: UUID(),
            plain: text,
            frets: Array(repeating: 0, count: instrument.strings.count),
            fingers: Array(repeating: 0, count: instrument.strings.count),
            baseFret: .one,
            root: .unknown,
            quality: .unknown,
            slash: nil,
            instrument: instrument,
            kind: kind,
            status: .text
        )
    }

    /// Init a Chord Definition with an empty C chord for the chord diagram editor
    /// - Parameter instrument: The ``Instrument`` for this definition
    /// 
    /// This is for the chord diagram editor
    public init(instrument: Instrument) {
        self.init(
            id: UUID(),
            plain: "",
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

    /// Init a Chord Definition with a `C` chord
    /// - Parameters:
    ///   - instrument: The ``Instrument`` for this definition
    ///   - chords: All the known chords
    ///
    /// If not found in the chords database, it will init an *empty* `C` chord
    public init(instrument: Instrument, chords: [ChordDefinition]) {
        if let chord = chords.matching(root: .c).matching(quality: .major).matching(slash: nil).matching(baseFret: .one).first {
            self = chord
        } else {
            self.init(instrument: instrument)
        }
    }
}
