//
//  ChordProParser+autoSection.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 21/11/2024.
//

import Foundation

extension ChordProParser {

    static func autoSection(
        environment: ChordPro.Environment,
        currentSection: inout Song.Section,
        song: inout Song
    ) -> String {
        currentSection.environment = environment
        currentSection.label = environment.label
        currentSection.autoCreated = true
        let line = Song.Section.Line(
            sourceLineNumber: -song.lines,
            environment: currentSection.environment,
            directive: environment.directives.open,
            source: "{\(environment.directives.open.rawValue.long)}"
        )
        currentSection.lines.append(line)
        return "No environment set, using **\(environment.label)**"
    }
}
