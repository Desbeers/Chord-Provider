//
//  Song+Section+Line+Part.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// A part in the ``Song/Section/Line``
    public struct Part: Identifiable, Equatable, Codable, Sendable {
        public init(
            id: Int = 0,
            chordDefinition: ChordDefinition? = nil,
            chord: ChordPro.Instrument.Chord? = nil,
            text: String? = nil,
            strum: Song.Section.Line.Strum.Action? = nil
        ) {
            self.id = id
            self.chordDefinition = chordDefinition
            self.chord = chord
            self.text = text
            self.strum = strum
        }

        /// The unique ID of the part
        public var id: Int
        /// The optional chord definition
        public var chordDefinition: ChordDefinition?
        /// The optional chord definition in **ChordPro** format
        public var chord: ChordPro.Instrument.Chord?
        /// The optional text
        public var text: String?
        /// The optional strum
        public var strum: Song.Section.Line.Strum.Action?
    }
}
