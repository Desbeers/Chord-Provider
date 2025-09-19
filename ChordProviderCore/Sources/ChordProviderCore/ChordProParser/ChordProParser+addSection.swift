//
//  ChordProParser+addSection.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Add a complete section to the song
    /// - Parameters:
    ///   - directive: The ``ChordPro/Directive`` to add to the line
    ///   - arguments: The optional arguments for the directive
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func addSection(
        directive: ChordPro.Directive,
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        openSection(
            directive: directive,
            arguments: arguments,
            currentSection: &currentSection,
            song: &song
        )
        song.sections.append(currentSection)
        currentSection = Song.Section(id: song.sections.count + 1)
    }
}
