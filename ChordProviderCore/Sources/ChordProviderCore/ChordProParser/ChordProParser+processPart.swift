//
//  ChordProParser+processPart.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a part of a line

    static func processPart(
            chord: String,
            text: String, 
            partID: Int,
            line: inout Song.Section.Line,
            song: inout Song
        ) -> Song.Section.Line.Part {
        var part = Song.Section.Line.Part(id: partID)
        if !chord.isEmpty {
            /// Check for markup
            let markup = String(chord).markup(handleBrackets: true)
            part.chordDefinition = processChord(
                chord: markup.text,
                line: &line,
                song: &song
            )
            if text.isEmpty {
                /// Add this chord to the length, it have no lyric attached
                line.lineLength = (line.lineLength ?? "") + " \(markup.text)"
            }
            /// Add optional markup
            part.chordMarkup = markup
        }
        if !text.isEmpty {
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
        return part
    }
}