//
//  ChordProParser+autoSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Create an automatic section in the ``Song``
    /// - Parameters:
    ///   - environment: The ``ChordPro/Environment`` of the section
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    /// - Returns: A warning as `String`
    static func autoSection(
        environment: ChordPro.Environment,
        currentSection: inout Song.Section,
        song: inout Song
    ) -> String {
        currentSection.environment = environment
        currentSection.label = environment.label
        currentSection.autoCreated = true
        let line = Song.Section.Line(
            sourceLineNumber: -song.lines,
            environment: currentSection.environment,
            directive: environment.directives.open,
            source: "{\(environment.directives.open.rawValue.long)}"
        )
        currentSection.lines.append(line)
        return "No environment set, using **\(environment.rawValue)**"
    }
}
