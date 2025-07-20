//
//  ChordProParser+processTab.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a tab environment

    /// Process a tab environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processTab(
        text: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        /// Start with a fresh line
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            source: text,
            sourceParsed: text.trimmingCharacters(in: .whitespaces),
            type: .songLine,
            plain: text.trimmingCharacters(in: .whitespaces)
        )
        /// Set the context
        line.context = currentSection.environment
        /// Add the line"
        currentSection.lines.append(line)
        /// Mark the section as Tab if not set
        if currentSection.environment == .none {
            autoSection(
                environment: .tab,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
