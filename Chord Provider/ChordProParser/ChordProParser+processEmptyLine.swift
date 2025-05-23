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
        if currentSection.environment != .none && currentSection.autoCreated == false {
            /// Add an empty line to the section
            var line = Song.Section.Line(
                sourceLineNumber: song.lines,
                environment: currentSection.environment,
                directive: .emptyLine,
                source: ""
            )
            /// Add an empty part
            let part = Song.Section.Line.Part(id: 1, chord: nil, text: "")
            line.parts = [part]
            currentSection.lines.append(line)
        } else {
            /// Add the empty line as a single line in a section
            addSection(
                /// - Note: add the raw source here, or else it will be calculated with a directive
                source: "",
                directive: .emptyLine,
                arguments: Arguments(),
                environment: .none,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
