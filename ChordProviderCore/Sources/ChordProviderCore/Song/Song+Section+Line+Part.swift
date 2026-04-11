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
            strum: Chord.Strum? = nil,
            chordMarkup: Song.Markup? = nil,
            textMarkup: [Song.Markup]? = nil
        ) {
            self.id = id
            self.chordDefinition = chordDefinition
            self.text = text
            self.strum = strum
            self.chordMarkup = chordMarkup
            self.textMarkup = textMarkup
        }

        /// The unique ID of the part
        public var id: Int
        /// The optional chord definition
        public var chordDefinition: ChordDefinition?
        /// The optional text
        public var text: String?

        /// The optional strum
        public var strum: Chord.Strum?

        // MARK: Markup

        /// The optional text with markup
        public var textMarkup: [Song.Markup]?
        /// The opional markup formatting for the chord
        public var chordMarkup: Song.Markup?
        /// Chord definition with markup
        public func withMarkup(_ chord: ChordDefinition) -> String {
            return "\(chordMarkup?.open ?? "")\(chord.display)\(chordMarkup?.close ?? "")"
        }
        /// All th text with markup
        /// 
        /// This will combine all text parts with markup into one string
        /// -Note: In use when rendering a part of a lyric or chorus
        public var allTextWithMarkup: String {
            if let textMarkup {
                return textMarkup.map { part in "\(part.open)\(part.text)\(part.close)"}.joined()
            }
            return ""
        }
    }
}
