//
//  ChordProParser+processSection.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a section

    /// Process a section
    /// - Parameters:
    ///   - label: The label of the `section`
    ///   - type: The type of `section`
    ///   - song: The `song`
    ///   - currentSection: The current `section` of the `song`
    static func processSection(
        label: String,
        type: ChordPro.Environment,
        song: inout Song,
        currentSection: inout Song.Section
    ) {
        if currentSection.lines.isEmpty {
            /// There is already an empty section
            currentSection.type = type
            currentSection.label = label
            currentSection.autoCreated = type == .none ? true : false
        } else {
            /// Make a new section
            song.sections.append(currentSection)
            currentSection = Song.Section(
                id: song.sections.count + 1,
                autoCreated: type == .none ? true : false
            )
            currentSection.type = type
            currentSection.label = label
        }
    }
}
