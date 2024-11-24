//
//  ChordProParser+addSection.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 19/11/2024.
//

import Foundation

extension ChordProParser {

    /// Add a complete section with a single directive in a line

    static func addSection(
        source: String? = nil,
        sectionLabel: String? = nil,
        directive: ChordPro.Directive,
        directiveLabel: String? = nil,
        environment: ChordPro.Environment,
        currentSection: inout Song.Section,
        song: inout Song
    ) {

        /// Preserve the optional warning in the current section
        let warning = currentSection.warning

        /// Close the current section if it has lines
        /// - Note: a new one will be created in that function
        if !currentSection.lines.isEmpty {
            closeSection(
                directive: directive,
                environment: environment,
                currentSection: &currentSection,
                song: &song
            )
        }
        /// Update the current section
        currentSection.environment = environment
        currentSection.label = sectionLabel ?? ""
        /// Calculate the source
        var calculatedSource = source ?? ""
        if source == nil {
            let label = directiveLabel ?? ""
            calculatedSource = "{\(directive.shortToLong.rawValue)" + (label.isEmpty ? "" : ": \(label)") + "}"
        }
        /// Add the single line
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            environment: environment,
            directive: directive,
            argument: directiveLabel ?? "",
            source: calculatedSource
        )
        /// Add the optional warning
        if let warning {
            line.addWarning(warning)
        }
        currentSection.lines.append(line)
        /// Close the section
        closeSection(
            directive: directive,
            environment: environment,
            currentSection: &currentSection,
            song: &song
        )
    }
}
