//
//  ChordProParser+autoSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Create an automatic section environment  in the ``Song``
    /// - Parameters:
    ///   - environment: The ``ChordPro/Environment`` of the section
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func autoSection(
        environment: ChordPro.Environment,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        currentSection.environment = environment
        currentSection.autoCreated = true
        if let firstLineIndex = currentSection.lines.firstIndex(where: { $0.type == .songLine }) {
            let line = Song.Section.Line(
                sourceLineNumber: -currentSection.lines[firstLineIndex].sourceLineNumber,
                source: "{\(environment.directives.open.rawValue.long)}",
                sourceParsed: "{\(environment.directives.open.rawValue.long)}",
                directive: environment.directives.open,
                arguments: nil,
                type: .environmentDirective,
                context: environment
            )
            /// Add a warning to the first line
            currentSection.lines[firstLineIndex].addWarning("No environment set, using **\(environment.rawValue)**")
            /// Set the new context
            currentSection.lines[firstLineIndex].context = environment
            /// Add the opening directive at the start
            currentSection.lines.insert(line, at: 0)
            /// Remember the longest label for an environment
            /// - Note: Used in PDF output to calculate label offset
            setLongestLabel(label: environment.label, song: &song)
        }
    }
}
