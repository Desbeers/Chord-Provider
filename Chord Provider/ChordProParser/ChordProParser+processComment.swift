//
//  ChordProParser+processComment.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 20/11/2024.
//

import Foundation

extension ChordProParser {

    static func processComment(
        arguments: Arguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        let comment = arguments[.plain] ?? ""
        if !currentSection.lines.isEmpty && currentSection.autoCreated == false {
            /// A comment inside a section
            var line = Song.Section.Line(
                sourceLineNumber: song.lines,
                environment: currentSection.environment,
                directive: .comment,
                arguments: [.plain: comment],
                source: "{\(ChordPro.Directive.comment) \(comment)}"
            )
            if let warning = currentSection.warning {
                line.addWarning(warning)
            }
            if comment.isEmpty {
                line.addWarning("The comment is empty")
            }
            currentSection.lines.append(line)
            /// Clear any warnings
            currentSection.resetWarnings()
        } else {
            /// A  comment in its own section
            if comment.isEmpty {
                currentSection.addWarning("The comment is empty")
            }
            addSection(
                directive: .comment,
                arguments: arguments,
                environment: .comment,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
