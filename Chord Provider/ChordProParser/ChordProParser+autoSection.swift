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
        if let firstLineIndex = currentSection.lines.firstIndex(where: { $0.directive == .environmentLine }) {
            /// Give it the default label as plain argument
            let arguments: DirectiveArguments = [.plain: environment.label]
            let line = Song.Section.Line(
                sourceLineNumber: -currentSection.lines[firstLineIndex].sourceLineNumber,
                directive: environment.directives.open,
                arguments: arguments,
                source: "{\(environment.directives.open.rawValue.long)}"
            )
            /// Add a warning to the first line
            currentSection.lines[firstLineIndex].addWarning("No environment set, using **\(environment.rawValue)**")
            /// Add the opening directive at the start
            currentSection.lines.insert(line, at: 0)
        }
    }
}
