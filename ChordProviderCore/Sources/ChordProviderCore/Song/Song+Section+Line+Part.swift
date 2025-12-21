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
            text: String? = nil,
            strum: Song.Section.Line.Strum.Action? = nil,
            textMarkup: Song.Markup? = nil,
            chordMarkup: Song.Markup? = nil
        ) {
            self.id = id
            self.chordDefinition = chordDefinition
            self.text = text
            self.strum = strum
            self.textMarkup = textMarkup
            self.chordMarkup = chordMarkup
        }

        /// The unique ID of the part
        public var id: Int
        /// The optional chord definition
        public var chordDefinition: ChordDefinition?
        /// The optional text
        public var text: String?
        /// The optional lyrics
        public var lyrics: [Song.Markup]?
        /// The optional strum
        public var strum: Song.Section.Line.Strum.Action?
        /// Pango formatting for the text
        public var textMarkup: Song.Markup?
        /// Pango formatting for the chord
        public var chordMarkup: Song.Markup?
        /// Plain text with markup
        public func withMarkup(_ text: String) -> String {
            return "\(textMarkup?.open ?? "")\(text)\(textMarkup?.close ?? "")"
        }
        /// Chord definition with arkup
        public func withMarkup(_ chord: ChordDefinition) -> String {
            return "\(chordMarkup?.open ?? "")\(chord.display)\(chordMarkup?.close ?? "")"
        }
        public var lyricsText: String {
            if let lyrics {
                return lyrics.map { lyric in "\(lyric.open)\(lyric.text)\(lyric.close)"}.joined()
            }
            return ""
        }
    }
}
