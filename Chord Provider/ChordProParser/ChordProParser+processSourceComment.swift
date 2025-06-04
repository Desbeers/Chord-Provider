//
//  ChordProParser+processSourceComment.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Process a source comment
    /// - Parameters:
    ///   - comment: The source comment
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processSourceComment(
        comment: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        if !currentSection.lines.isEmpty && currentSection.autoCreated == false {
            /// A source comment inside a section
            let line = Song.Section.Line(
                sourceLineNumber: song.lines,
                environment: currentSection.environment,
                directive: .sourceComment,
                source: comment
            )
            currentSection.lines.append(line)
        } else {
            /// A source comment in its own section
            addSection(
                /// - Note: add the raw source here, or else it will be calculated with a directive
                source: comment,
                directive: .sourceComment,
                arguments: DirectiveArguments(),
                environment: .none,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
