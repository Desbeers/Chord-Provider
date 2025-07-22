//
//  ChordProParser+processLine.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a line

    /// Process a line
    /// - Parameters:
    ///   - text: The text to process
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processLine(
        text: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        /// Check if we have chords, if so, set the environment to Verse if not yet set.
        var haveChords: Bool = false
        /// Start with a fresh line:
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            source: text,
            sourceParsed: text.trimmingCharacters(in: .whitespaces),
            type: .songLine
        )
        /// Remove markup, if any, **Chord Provider** does not support it
        let textCopy = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        if text != textCopy {
            line.addWarning("**Chord Provider** does not support inline markup")
        }
        var partID: Int = 1
        /// All the parts in the line
        var parts: [Song.Section.Line.Part] = []
        /// Chop the line in parts
        var matches = textCopy.matches(of: Chord.RegexDefinitions.line)
        /// The last match is the newline character so completely empty; we don't need it
        matches = matches.dropLast()
        for match in matches {
            let (_, chord, lyric) = match.output
            var part = Song.Section.Line.Part(id: partID)
            if let chord {
                part.chordDefinition = processChord(
                    chord: String(chord),
                    line: &line,
                    song: &song
                )
                /// Because it has a chord; the section should be at least a verse
                haveChords = true
                /// Official **ChordPro** compatibility
                // part.chord = part.chordDefinition?.chordProJSON
            }
            if let lyric {
                part.text = String(lyric)
                /// Add the lyrics to the 'plain' text
                line.plain = (line.plain ?? "") + lyric
                line.lineLength = (line.lineLength ?? "") + String(lyric)
            } else if let chord {
                line.lineLength = (line.lineLength ?? "") + " \(String(chord)) "
            }
            /// Add the part
            parts.append(part)
            /// Increase the ID
            partID += 1
        }

        /// Calculate the source
//        line.sourceParsed = parts.map { part in
//            var string = ""
//            if let chord = part.chordDefinition {
//                string += "[\(chord.getName)]"
//            }
//            if let text = part.text {
//                string += text
//            }
//            return string
//        }
//        .joined()

        line.parts = parts
        /// Set the context
        line.context = currentSection.environment
        /// Add the line
        currentSection.lines.append(line)
        /// Set the environment to Verse if not yet set and we have chords, else to Textblock
        if currentSection.environment == .none {
            autoSection(
                environment: haveChords ? .verse : .textblock,
                currentSection: &currentSection,
                song: &song
            )
        }
        /// Remember the longest line in the song
        if currentSection.environment == .chorus || currentSection.environment == .verse {
            if line.lineLength?.count ?? 0 > song.metadata.longestLine.lineLength?.count ?? 0 {
                song.metadata.longestLine = line
            }
        }
    }
}
