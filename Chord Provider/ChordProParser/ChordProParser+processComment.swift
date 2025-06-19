//
//  ChordProParser+processComment.swift
//  Chord Provider
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
        if currentSection.environment == .none || currentSection.environment == .metadata {
            /// A  comment in its own section
            if comment.isEmpty {
                currentSection.addWarning("The comment is empty")
            }
            addSection(
                directive: .comment,
                arguments: arguments,
                currentSection: &currentSection,
                song: &song
            )
            /// Set the environment to none again
            currentSection.environment = .none
        } else {
            /// A comment inside a section
            var line = Song.Section.Line(
                sourceLineNumber: song.lines,
                directive: .comment,
                arguments: arguments,
                source: "{\(ChordPro.Directive.comment) \(comment)}",
                plain: comment
            )
            if let warning = currentSection.warnings {
                line.addWarning(warning)
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
