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
        /// Chop the comments in parts to deal with markup
        let textMarkup = comment.matches(of: RegexDefinitions.lineSeparator).map { match in
            String(match.0).markup(handleBrackets: false)
        }
        /// A comment should be rendered as part of a line, so create a part
        let part = Song.Section.Line.Part(textMarkup: textMarkup)
        if currentSection.environment == .none || currentSection.environment == .metadata {
            /// A comment in its own section
            if comment.isEmpty {
                currentSection.addWarning("The comment is empty")
            }
            addSection(
                directive: .comment,
                arguments: arguments,
                part: part,
                currentSection: &currentSection,
                song: &song
            )
            /// Set the environment to none again
            currentSection.environment = .none
        } else {
            /// A comment inside a section
            var line = Song.Section.Line(
                sourceLineNumber: song.lines,
                source: "{\(ChordPro.Directive.comment) \(comment)}",
                sourceParsed: "{\(ChordPro.Directive.comment) \(comment.trimmingCharacters(in: .whitespaces))}",
                directive: .comment,
                type: .comment,
                context: currentSection.environment,
                plain: comment
            )
            /// Add the part
            line.parts = [part]
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
