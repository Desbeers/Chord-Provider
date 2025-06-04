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
        /// Start with a fresh line:
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            directive: .environmentLine,
            source: text
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
                /// Add the lyrics to the 'plain' text
                line.plain += part.text
            }
            if part.hasContent {
                partID += 1
                parts.append(part)
            }
        }
        line.parts = parts
        /// If we still don't know whet environment it is, make it a textblock
        if currentSection.environment == .none {
            line.addWarning(
                autoSection(
                    environment: .textblock,
                    currentSection: &currentSection,
                    song: &song
                )
            )
        }
        /// Set the correct environment
        line.environment = currentSection.environment
        /// Remember the longest line in the song
        if currentSection.environment == .chorus || currentSection.environment == .verse {
            if line.plain.count > song.metadata.longestLine.count {
                song.metadata.longestLine = line.plain
            }
        }
        /// Add the line
        currentSection.lines.append(line)
    }
}
