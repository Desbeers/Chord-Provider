//
//  Song+Section+Line+Part.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// A part in the ``Song/Section/Line``
    struct Part: Identifiable, Equatable, Codable {
        /// The unique ID of the part
        var id: Int
        /// The optional chord definition
        var chordDefinition: ChordDefinition?
        /// The optional chord definition in **ChordPro** format
        var chord: ChordPro.Instrument.Chord?
        /// The optional text
        var text: String?
    }
}
