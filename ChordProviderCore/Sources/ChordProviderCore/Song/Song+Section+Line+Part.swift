//
//  Song+Section+Line+Part.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// A part in the ``Song/Section/Line``
    public struct Part: Identifiable, Equatable, Codable, Sendable, CustomStringConvertible {
        public init(
            id: Int = 0,
            chordDefinition: ChordDefinition? = nil,
            textChord: String? = nil,
            text: String? = nil,
            strum: Strum? = nil,
            cells: Int? = nil,
            chordMarkup: Song.Markup? = nil,
            textMarkup: [Song.Markup]? = nil
        ) {
            self.id = id
            self.chordDefinition = chordDefinition
            self.textChord = textChord
            self.text = text
            self.strum = strum
            self.chordMarkup = chordMarkup
            self.textMarkup = textMarkup
        }

        // CustomStringConvertible protocol
        public var description: String {
            "\(chordDefinition?.description ?? "")\(text ?? "")\(strum?.description ?? "")"
        }

        /// The unique ID of the part
        public var id: Int
        /// The optional chord definition
        public var chordDefinition: ChordDefinition?
        /// The optional text in a chord position
        public var textChord: String?
        /// The optional text
        public var text: String?
        /// Bool if the part should be dimmed in a view
        public var dimmed: Bool = false

        /// The optional strum
        public var strum: Strum?

        // MARK: Markup

        /// The optional text with markup
        public var textMarkup: [Song.Markup]?
        /// The opional markup formatting for the chord
        public var chordMarkup: Song.Markup?
        /// Chord definition with markup
        public var chordWithMarkup: String {
            return "\(chordMarkup?.open ?? "")\(chordDefinition?.display ?? textChord ?? "?")\(chordMarkup?.close ?? "")"
        }
        /// All the text with markup
        /// 
        /// This will combine all text parts with markup into one string
        /// - Note: In use when rendering a part of a lyric or chorus
        public var allTextWithMarkup: String {
            if let textMarkup {
                return textMarkup.compactMap { part in
                    "\(part.open)\(part.text.escapeSpecialCharacters())\(part.close)"
                }.joined()
            }
            return text?.escapeSpecialCharacters() ?? ""
        }
    }
}
