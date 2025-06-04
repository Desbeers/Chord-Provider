//
//  ChordProParser+openSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Open a new section in the song
    /// - Parameters:
    ///   - source: The optional generated source
    ///   - directive: The ``ChordPro/Directive`` to add to the line
    ///   - arguments: The optional arguments for the directive
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func openSection(
        source: String? = nil,
        directive: ChordPro.Directive,
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {

        /// Add the directive in its own section
        addSection(
            source: source,
            directive: directive,
            arguments: arguments,
            currentSection: &currentSection,
            song: &song
        )

        /// Update the current section
        currentSection.environment = directive.details.environment
        currentSection.label = arguments[.plain] ?? arguments[.label] ?? directive.details.environment.label
    }
}
