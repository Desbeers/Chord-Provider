//
//  ChordProParser+processSourceComment.swift
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
                /// - Note: add the raw source here, or else it will be calculated with a directive
                source: comment,
                directive: .sourceComment,
                arguments: Arguments(),
                environment: .none,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
