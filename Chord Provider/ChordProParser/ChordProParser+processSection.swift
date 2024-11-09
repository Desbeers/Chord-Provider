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
        if type != .none, currentSection.type == type {
            song.log.append(.init(type: .warning, lineNumber: song.lines, message: "Already in \(type.rawValue) context"))
        }
        if currentSection.lines.isEmpty {
            /// There is already an empty section
            currentSection.type = type
            currentSection.label = label
            currentSection.autoCreated = false
        } else {
            song.sections.append(currentSection)
            /// Make a new section
            currentSection = Song.Section(
                id: song.sections.count + 1,
                autoCreated: false
            )
            currentSection.type = type
            currentSection.label = label
        }
    }
}
