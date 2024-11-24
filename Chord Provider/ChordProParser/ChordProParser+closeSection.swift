//
//  ChordProParser+closeSection.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 19/11/2024.
//

import Foundation

extension ChordProParser {

    /// Close a section in the song
    /// - Note: This will open a new empty section as well
    /// - Parameters:
    ///   - label: The optional label of the section
    ///   - directive: The ``ChordPro/Directive`` of the section
    ///   - environment: The ``ChordPro/Environment`` of the section
    ///   - currentSection: The current section of the song
    ///   - song: The song itself
    static func closeSection(
        directive: ChordPro.Directive,
        environment: ChordPro.Environment,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        /// Add the closing directive for an automatic created environment
        if currentSection.autoCreated {
            let line = Song.Section.Line(
                sourceLineNumber: -song.lines,
                environment: currentSection.environment,
                directive: currentSection.environment.directives.close,
                source: "{\(currentSection.environment.directives.close.rawValue)}"
            )
            currentSection.lines.append(line)
        }
        /// Close the current section if it has lines
        if !currentSection.lines.isEmpty {
            song.sections.append(currentSection)
            currentSection = Song.Section(id: song.sections.count + 1, autoCreated: false)
        }
    }
}
