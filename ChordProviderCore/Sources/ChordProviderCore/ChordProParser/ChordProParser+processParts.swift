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
            var lyric = Song.Section.Line.Part.Content.Lyric()
            if let chord {
                /// Check for optional prefix or suffix
                var textPart = String(chord).textPart(handleBrackets: true)
                textPart.suffix += " "
                /// Check if it is just a text chord
                if textPart.text.first == "*" {
                    /// It is, add it as a 'text chord'
                    textPart.text = String(textPart.text.dropFirst())
                    lyric.chordSlot = .text(textPart: textPart)
                } else if textPart.text == "N.C." || textPart.text == "NC" {
                    textPart.text = "X"
                    lyric.chordSlot = .text(textPart: textPart)
                } else {
                    /// It is a chord definition
                    let definition = processChord(
                        chord: textPart.text,
                        line: &line,
                        song: &song
                    )
                    textPart.text = definition.display
                    lyric.chordSlot = .chord(definition: definition, textPart: textPart)
                }
                if text == nil {
                    /// Add this chord to the length, it have no lyric attached
                    line.lineLength = (line.lineLength ?? "") + " \(textPart.text)"
                }
            }
            if let text {
                let textParts = String(text).matches(of: RegexDefinitions.lineSeparator).map { match in
                    String(match.0).textPart(handleBrackets: false)
                }
                /// Add the lyrics to the line lenght
                line.lineLength = (line.lineLength ?? "") + textParts.flatMap(\.text)
                lyric.textParts = textParts
            }
            part.content = .lyric(content: lyric)
            /// Add the part
            parts.append(part)
            /// Increase the ID
            partID += 1
        }
        line.parts = parts
    }
}