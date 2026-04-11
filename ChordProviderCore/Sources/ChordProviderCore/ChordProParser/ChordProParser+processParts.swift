//
//  ChordProParser+processParts.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process parts of a line

    static func processParts(
            text: String,
            line: inout Song.Section.Line,
            song: inout Song
        ) {
        var partID: Int = 1
        /// All the parts in the line
        var parts: [Song.Section.Line.Part] = []
        /// Chop the line in parts
        var matches = text.matches(of: RegexDefinitions.lineParts)
        /// The last match is the newline character so completely empty; we don't need it
        matches = matches.dropLast()
        for match in matches {
            let (_, chord, text) = match.output
            var part = Song.Section.Line.Part(id: partID)
            if let chord {
                /// Check for markup
                let markup = String(chord).markup(handleBrackets: true)
                part.chordDefinition = processChord(
                    chord: markup.text,
                    line: &line,
                    song: &song
                )
                if text == nil {
                    /// Add this chord to the length, it have no lyric attached
                    line.lineLength = (line.lineLength ?? "") + " \(markup.text)"
                }
                /// Add optional markup
                part.chordMarkup = markup
            }
            if let text {
                let parts = String(text).matches(of: RegexDefinitions.lineSeparator).map { match in
                    String(match.0).markup(handleBrackets: false)
                }
                part.textMarkup = parts
                part.text = parts.map((\.text)).joined()
                if let text = part.text {
                    /// Add the lyrics to the 'plain' text
                    line.plain = (line.plain ?? "") + text
                    line.lineLength = (line.lineLength ?? "") + text
                }
            }
            /// Add the part
            parts.append(part)
            /// Increase the ID
            partID += 1
        }
        line.parts = parts
    }
}