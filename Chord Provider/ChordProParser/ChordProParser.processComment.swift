//
//  ChordProParser.processComment.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 20/11/2024.
//

import Foundation

extension ChordProParser {

    static func processComment(
        comment: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        if !currentSection.lines.isEmpty && currentSection.autoCreated == false {
            /// A comment inside a section
            let line = Song.Section.Line(
                sourceLineNumber: song.lines,
                environment: currentSection.environment,
                directive: .comment,
                argument: comment,
                source: "{\(ChordPro.Directive.comment.rawValue): \(comment)}"
            )
            currentSection.lines.append(line)
        } else {
            /// A  comment in its own section
            addSection(
                sectionLabel: comment,
                directive: .comment,
                directiveLabel: comment,
                environment: .comment,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
