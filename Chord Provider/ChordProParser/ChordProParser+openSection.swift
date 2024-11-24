//
//  ChordProParser+openSection.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 19/11/2024.
//

import Foundation

extension ChordProParser {

    /// Open a new section in the song
    /// - Parameters:
    ///   - label: The optional label of the section
    ///   - directive: The ``ChordPro/Directive`` of the section
    ///   - environment: The ``ChordPro/Environment`` of the section
    ///   - currentSection: The current section of the song
    ///   - song: The song itself
    static func openSection(
        sectionLabel: String?,
        directive: ChordPro.Directive,
        directiveLabel: String?,
        environment: ChordPro.Environment,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        /// Add the directive in its own section
        addSection(
            sectionLabel: sectionLabel,
            directive: directive,
            directiveLabel: directiveLabel,
            environment: .metadata,
            currentSection: &currentSection,
            song: &song
        )
        /// Update the current section
        currentSection.environment = environment
        currentSection.label = sectionLabel ?? ""
    }
}
