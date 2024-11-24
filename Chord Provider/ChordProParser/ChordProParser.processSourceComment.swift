//
//  ChordProParser.processSourceComment.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 18/11/2024.
//

import Foundation

extension ChordProParser {

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
                source: comment,
                sectionLabel: ChordPro.Directive.sourceComment.label,
                directive: .sourceComment,
                environment: .metadata,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
