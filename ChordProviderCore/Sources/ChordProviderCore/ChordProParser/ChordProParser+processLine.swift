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
        /// Start with a fresh line:
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
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
        if currentSection.environment == .none || currentSection.autoCreated ?? false {
            /// Check for chords
            if !currentSection.haveChords {
                currentSection.haveChords = line.parts?.compactMap(\.chordDefinition).isEmpty ?? false ? false : true
            }
            autoSection(
                environment: currentSection.haveChords ? .verse : .textblock,
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
