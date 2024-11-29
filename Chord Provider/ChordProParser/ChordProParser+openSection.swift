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
    ///   - directive: The ``ChordPro/Directive`` to add to the line
    ///   - arguments: The optional arguments for the directive
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func openSection(
        directive: ChordPro.Directive,
        arguments: Arguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {

        /// Add the directive in its own section
        addSection(
            directive: directive,
            arguments: arguments,
            currentSection: &currentSection,
            song: &song
        )

        /// Update the current section
        currentSection.environment = directive.environment
        currentSection.label = arguments[.plain] ?? arguments[.label] ?? directive.environment.label
    }
}
