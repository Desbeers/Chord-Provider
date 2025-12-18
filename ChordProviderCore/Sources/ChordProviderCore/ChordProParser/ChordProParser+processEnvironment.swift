//
//  ChordProParser+processEnvironment.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process an environment

    /// Process an environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processEnvironment(
        text: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        switch currentSection.environment {
        case .tab:
            /// A tab can start with '|--02-3-4|', but also with 'E|--2-3-4| for example
            processTab(text: text, currentSection: &currentSection, song: &song)
        case .grid:
            processGrid(text: text, currentSection: &currentSection, song: &song)
        case .strum:
            processStrum(text: text, currentSection: &currentSection, song: &song)
        case .textblock:
            processTextblock(text: text, currentSection: &currentSection, song: &song)
        default:
            /// Treat as normal song line
            processLine(text: text, currentSection: &currentSection, song: &song)
        }
    }
}
