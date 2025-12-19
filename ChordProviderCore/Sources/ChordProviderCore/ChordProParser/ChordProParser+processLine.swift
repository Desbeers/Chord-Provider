//
//  ChordProParser+processLine.swift
//  ChordProviderCore
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
        var partID: Int = 1
        /// All the parts in the line
        var parts: [Song.Section.Line.Part] = []
        /// Chop the line in parts
        var matches = text.matches(of: ChordPro.RegexDefinitions.line)
        /// The last match is the newline character so completely empty; we don't need it
        matches = matches.dropLast()
        for match in matches {

            let (_, chord, lyric) = match.output
            var part = Song.Section.Line.Part(id: partID)
            if let chord {
                /// Check for pango markup
                let markup = String(chord).markup
                part.chordDefinition = processChord(
                    chord: markup.text,
                    line: &line,
                    song: &song
                )
                line.lineLength = (line.lineLength ?? "") + " \(markup.text) "
                /// Because it has a chord; the section should be at least a verse
                haveChords = true
                /// Add optional markup
                part.chordMarkup = markup
            }
            if let lyric {
                let parts = String(lyric).matches(of: ChordPro.RegexDefinitions.markupSeparator).map { match in
                    String(match.0).markup
                }
                part.lyrics = parts
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
