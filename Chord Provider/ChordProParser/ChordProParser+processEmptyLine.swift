//
//  ChordProParser+processEmptyLine.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Process an empty line
    /// - Parameters:
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processEmptyLine(
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        if currentSection.environment != .none && currentSection.autoCreated ?? false == false {
            /// Add an empty line to the section
            let line = Song.Section.Line(
                sourceLineNumber: song.lines,
                source: "",
                sourceParsed: "",
                type: .emptyLine,
                context: currentSection.environment
            )
            currentSection.lines.append(line)
        } else {
            var arguments = DirectiveArguments()
            arguments[.source] = ""
            /// Add the empty line as a single line in a section
            addSection(
                directive: .emptyLine,
                arguments: arguments,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
