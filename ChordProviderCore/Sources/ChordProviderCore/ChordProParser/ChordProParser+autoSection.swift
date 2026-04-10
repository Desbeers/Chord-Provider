//
//  ChordProParser+autoSection.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Create an automatic section environment  in the ``Song``
    /// - Parameters:
    ///   - environment: The ``ChordPro/Environment`` of the section
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func autoSection(
        environment: ChordPro.Environment,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        currentSection.environment = environment
        currentSection.autoCreated = true
        /// Update all the lines
        let lines = currentSection.lines.map { line in
            var copy = line
            copy.context = environment
            return copy
        }
        currentSection.lines = lines
    }
}
