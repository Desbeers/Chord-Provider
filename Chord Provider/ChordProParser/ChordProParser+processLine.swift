//
//  ChordProParser+processLine.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a line

    /// Process a line
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    static func processLine(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line:
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            environment: currentSection.environment,
            directive: .environmentLine,
            source: text
        )
        var partID: Int = 1
        /// All the parts in the ine
        var parts: [Song.Section.Line.Part] = []
        /// Chop the line in parts
        var matches = text.matches(of: RegexDefinitions.line)
        /// The last match is the newline character so completely empty; we don't need it
        matches = matches.dropLast()
        for match in matches {
            let (_, chord, lyric) = match.output
            var part = Song.Section.Line.Part(id: partID)
            if let chord {
                part.chord = processChord(
                    chord: String(chord),
                    line: &line,
                    song: &song
                ).id
                part.text = " "
                /// Because it has a chord; it should be at least a verse
                if currentSection.environment == .none {
                    line.addWarning(
                        autoSection(
                            environment: .verse,
                            currentSection: &currentSection,
                            song: &song
                        )
                    )
                }
            }
            if let lyric {
                part.text = String(lyric)
            }
            if part.hasContent {
                partID += 1
                parts.append(part)
            }
        }
        line.parts = parts
        currentSection.lines.append(line)
    }
}
