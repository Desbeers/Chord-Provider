//
//  ChordProParser+processDefine.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a chord definition

    /// Process a chord definition
    /// - Parameters:
    ///   - text: The chord definition
    ///   - song: The `song`
    static func processDefine(
        label: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        do {
        var definedChord = try ChordDefinition(
            definition: label,
            instrument: song.settings.display.instrument,
            status: .unknownChord
        )
            definedChord.status = song.metadata.transpose == 0 ? definedChord.status : .customTransposedChord
            /// Update a standard chord with the same name if there is one in the chords list
            if let index = song.chords.firstIndex(where: {
                $0.name == definedChord.name &&
                ($0.status == .standardChord || $0.status == .transposedChord)
            }) {
                /// Use the same ID as the standard chord
                definedChord.id = song.chords[index].id
                song.chords[index] = definedChord
            } else {
                /// Add the chord as a new definition
                song.chords.append(definedChord)
            }
        } catch {
            /// The definition could not be processed
            currentSection.warning = "Wrong chord definition: \(error.localizedDescription)"
        }
        addSection(
            sectionLabel: label,
            directive: .define,
            directiveLabel: label,
            environment: .metadata,
            currentSection: &currentSection,
            song: &song
        )
    }
}
