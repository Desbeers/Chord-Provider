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
        var matches = text.matches(of: RegexDefinitions.lineParts)
        /// The last match is the newline character so completely empty; we don't need it
        matches = matches.dropLast()
        for match in matches {
            let (_, chord, lyric) = match.output

            let chordMatch = String(chord ?? "")
            let lyricMatch = String(lyric ?? "")
            haveChords = chordMatch.isEmpty ? false : true
            let part = processPart(
                chord: chordMatch,
                text: lyricMatch,
                partID: partID,
                line: &line,
                song: &song
            )
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
        if currentSection.environment == .none || currentSection.autoCreated ?? false {
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
