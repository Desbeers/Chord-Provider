//
//  ChordProParser+processLine.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
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
            sourceLineNumber: song.totalLines,
            source: text,
            sourceParsed: text.trimmingCharacters(in: .whitespaces),
            type: .songLine
        )
        processParts(text: text, line: &line, song: &song)
        /// Set the context
        line.context = currentSection.environment
        /// Add the line
        currentSection.lines.append(line)
        /// Set the environment to Verse if not yet set and we have chords, else to Textblock
        if currentSection.environment == .unknown || currentSection.autoCreated {
            /// Check for chords
            if !currentSection.haveChords {
                currentSection.haveChords = line.parts.map(\.content).compactMap(\.lyricHasChord).contains(true)
            }
            autoSection(
                environment: currentSection.haveChords ? .verse : .textblock,
                currentSection: &currentSection
            )
        }
        /// Remember the longest line in the song
        if currentSection.environment == .chorus || currentSection.environment == .verse {
            if let lineLength = line.lineLength, lineLength.count > song.metadata.longestLineLenght {
                song.metadata.longestLine = lineLength
            }
        }
    }
}
