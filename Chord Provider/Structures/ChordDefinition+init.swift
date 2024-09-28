//
//  ChordDefinition+init.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension ChordDefinition {

    // MARK: Init from the decoder

    /// Init the ``ChordDefinition`` from the decoder
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<ChordDefinition.CodingKeys> = try decoder.container(keyedBy: ChordDefinition.CodingKeys.self)
        /// Database values
        self.id = try container.decode(UUID.self, forKey: ChordDefinition.CodingKeys.id)
        self.frets = try container.decode([Int].self, forKey: ChordDefinition.CodingKeys.frets)
        self.fingers = try container.decode([Int].self, forKey: ChordDefinition.CodingKeys.fingers)
        self.baseFret = try container.decode(Int.self, forKey: ChordDefinition.CodingKeys.baseFret)
        self.root = try container.decode(Chord.Root.self, forKey: ChordDefinition.CodingKeys.root)
        self.quality = try container.decode(Chord.Quality.self, forKey: ChordDefinition.CodingKeys.quality)
        self.bass = try container.decodeIfPresent(Chord.Root.self, forKey: ChordDefinition.CodingKeys.bass)
        /// Calculated values
        self.name = "\(root.rawValue)\(quality.rawValue)"
        self.barres = Utils.fingersToBarres(frets: frets, fingers: fingers, baseFret: baseFret)
        self.components = Utils.fretsToComponents(root: root, frets: frets, baseFret: baseFret, instrument: .guitarStandardETuning)
        self.status = .standardChord
        self.instrument = .guitarStandardETuning
    }

    /// Init the ``ChordDefinition`` with all known values
    init(
        id: UUID,
        name: String,
        frets: [Int],
        fingers: [Int],
        baseFret: Int,
        root: Chord.Root,
        quality: Chord.Quality,
        bass: Chord.Root?,
        instrument: Instrument,
        status: Chord.Status = .customChord
    ) {
        self.id = id
        self.frets = frets
        self.fingers = fingers
        self.baseFret = baseFret
        self.root = root
        self.quality = quality
        self.bass = bass
        self.name = name
        self.instrument = instrument
        self.status = status
        /// Calculated values
        self.components = Utils.fretsToComponents(root: root, frets: frets, baseFret: baseFret, instrument: instrument)
        self.barres = Utils.fingersToBarres(frets: frets, fingers: fingers, baseFret: baseFret)
    }

    // MARK: Init with a definition

    /// Init the ``ChordDefinition`` with a **ChordPro** definition
    ///
    /// If the status is 'unknown', this function will try to find the chord in the database
    ///
    /// - Parameters:
    ///   - definition: The **ChordPro** definition
    ///   - instrument: The ``Instrument``
    ///   - status: The ``Chord/Status``
    init(definition: String, instrument: Instrument, status: Chord.Status) throws {
        /// Parse the chord definition
        do {
            let definition = try Utils.define(from: definition, instrument: instrument)
            /// Set the properties
            self.id = UUID()
            self.frets = definition.frets
            self.fingers = definition.fingers
            self.baseFret = definition.baseFret
            self.root = definition.root
            self.quality = definition.quality
            self.name = definition.name
            self.bass = definition.bass
            self.instrument = instrument
            self.status = status
            if status == .unknownChord {
                /// Get the optional matching chords
                let chords = Chords.getAllChordsForInstrument(instrument: instrument)
                    .matching(root: definition.root)
                    .matching(quality: definition.quality)
                    .matching(bass: definition.bass)
                /// See if we can find it
                if chords.firstIndex(where: { $0.frets == definition.frets && $0.baseFret == definition.baseFret }) != nil {
                    self.status = .standardChord
                } else {
                    self.status = .customChord
                }
            }
            /// Calculated values
            self.components = Utils.fretsToComponents(root: root, frets: frets, baseFret: baseFret, instrument: instrument)
            self.barres = Utils.fingersToBarres(frets: frets, fingers: fingers, baseFret: baseFret)
        } catch {
            throw error
        }
    }

    // MARK: Init with a name

    /// Init the ``ChordDefinition`` with the name of a chord
    ///
    /// - Parameters:
    ///   - name: The name of the chord, e.g 'Am7'
    ///   - instrument: The ``Instrument``
    init?(name: String, instrument: Instrument) {
        /// Parse the chord name
        let elements = Analizer.findChordElements(chord: name)
        /// Get the chords for the instrument
        let chords = Chords.getAllChordsForInstrument(instrument: instrument)
        /// See if we can find it
        guard
            let root = elements.root,
            let quality = elements.quality,
            let chord = chords.matching(root: root).matching(quality: quality).matching(bass: elements.bass).first
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
        self.bass = elements.bass
        self.name = name
        self.instrument = instrument
        self.status = .standardChord
        /// Calculated values
        self.components = Utils.fretsToComponents(root: root, frets: frets, baseFret: baseFret, instrument: instrument)
        self.barres = Utils.fingersToBarres(frets: frets, fingers: fingers, baseFret: baseFret)
    }

    // MARK: Init with an unknown name

    /// Init the ``ChordDefinition`` with an unknown chord
    ///
    /// - Parameters:
    ///   - unknown: The name of the unknown chord
    ///   - instrument: The ``Instrument``
    init(unknown: String, instrument: Instrument) {
        /// Set the properties
        self.id = UUID()
        self.frets = []
        self.fingers = []
        self.baseFret = 0
        self.root = .c
        self.quality = .major
        self.bass = nil
        self.name = unknown
        self.instrument = instrument
        self.status = .unknownChord
        /// Calculated values
        self.components = []
        self.barres = []
    }
}
