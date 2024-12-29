//
//  ChordProParser+closeSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Close a section in the song
    /// - Note: This will open a new empty section as well
    /// - Parameters:
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func closeSection(
        currentSection: inout Song.Section,
        song: inout Song
    ) {

        /// Add the closing directive for an automatic created environment
        if currentSection.autoCreated {
            let line = Song.Section.Line(
                sourceLineNumber: -song.lines,
                environment: currentSection.environment,
                directive: currentSection.environment.directives.close,
                source: "{\(currentSection.environment.directives.close.rawValue.long)}"
            )
            currentSection.lines.append(line)
        }

        /// Clear any warnings in the section; they should be handled now
        currentSection.resetWarnings()

        /// Close the current section if it has lines
        if !currentSection.lines.isEmpty {
            song.sections.append(currentSection)
            currentSection = Song.Section(id: song.sections.count + 1, autoCreated: false)
        }
    }
}
