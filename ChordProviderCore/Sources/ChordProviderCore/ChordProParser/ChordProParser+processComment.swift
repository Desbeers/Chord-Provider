//
//  ChordProParser+processComment.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Process a comment
    /// - Parameters:
    ///   - arguments: The optional arguments for the directive
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processComment(
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        let comment = arguments[.plain] ?? ""
        /// Set the source
        let source = arguments[.source]
        /// A comment should be rendered as part of a line
        var line = Song.Section.Line(
            sourceLineNumber: song.totalLines,
            source: source ?? "No source given, this is an error",
            sourceParsed: "{\(ChordPro.Directive.comment): \(comment.trimmingCharacters(in: .whitespaces))}",
            directive: .comment,
            type: .comment,
            context: currentSection.environment
        )
        processParts(text: comment, line: &line, song: &song)
        /// Check where the comment belongs
        if currentSection.environment == .none || currentSection.environment == .metadata {
            /// A comment in its own section
            if comment.isEmpty {
                currentSection.addWarning("The comment is empty")
            }
            addSection(
                directive: .comment,
                arguments: arguments,
                line: line,
                currentSection: &currentSection,
                song: &song
            )
            /// Set the environment to none again
            currentSection.environment = .none
        } else {
            /// A comment inside a section
            if let warnings = currentSection.warnings {
                for warning in warnings {
                    line.addWarning(warning, level: warning.level)
                }
            }
            if comment.isEmpty {
                line.addWarning("The comment is empty")
            }
            currentSection.lines.append(line)
            /// Clear any warnings
            currentSection.resetWarnings()
        }
    }
}
