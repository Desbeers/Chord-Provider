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
        var arguments: ChordProParser.DirectiveArguments = [.plain: comment]
        if (!currentSection.lines.isEmpty && currentSection.autoCreated ?? false == false) || currentSection.environment == .textblock {
            /// A source comment inside a section
            let line = Song.Section.Line(
                sourceLineNumber: song.lines,
                source: comment,
                sourceParsed: comment.trimmingCharacters(in: .whitespaces),
                directive: currentSection.environment == .textblock ? nil : .sourceComment,
                type: currentSection.environment == .textblock ? .songLine : .sourceComment,
                context: currentSection.environment == .textblock ? .textblock : .sourceComment,
                plain: comment.trimmingCharacters(in: .whitespaces)
            )
            currentSection.lines.append(line)
        } else {
            /// A source comment in its own section
            arguments[.source] = comment
            addSection(
                directive: .sourceComment,
                arguments: arguments,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
