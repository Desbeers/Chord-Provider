//
//  ChordProParser+processTextblock.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a texblock environment

    /// Process a texblock environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processTextblock(
        text: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        /// Start with a fresh line
        let line = Song.Section.Line(
            sourceLineNumber: song.lines,
            directive: .environmentLine,
            source: text,
            sourceParsed: text.trimmingCharacters(in: .whitespaces),
            plain: text.trimmingCharacters(in: .whitespaces)
        )
        currentSection.lines.append(line)
    }
}
