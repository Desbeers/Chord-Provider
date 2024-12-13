//
//  ChordProParser+processTab.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a tab environment

    /// Process a tab environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    static func processTab(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line
        let line = Song.Section.Line(
            sourceLineNumber: song.lines,
            environment: .tab,
            directive: .environmentLine,
            arguments: [.plain: text.trimmingCharacters(in: .newlines)],
            source: text.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        currentSection.lines.append(line)
        /// Mark the section as Tab if not set
        if currentSection.environment == .none {
            currentSection.environment = .tab
            currentSection.label = ChordPro.Environment.tab.label
        }
    }
}
