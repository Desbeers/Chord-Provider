//
//  ChordProParser+processDefine.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a chord definition for a specific instrument

    /// Process a chord definition for a specific instrument
    /// - Parameters:
    ///   - instrument: The instrument
    ///   - arguments: The directive arguments
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processDefine(
        instrument: Chord.Instrument,
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        if song.settings.instrument == instrument {
            processDefine(arguments: arguments, currentSection: &currentSection, song: &song)
        } else {
            /// The definition is for another instrument
            currentSection.addWarning("The chord definition is for **\(instrument.rawValue)** and will be ignored")
            addSection(
                directive: .define,
                arguments: arguments,
                currentSection: &currentSection,
                song: &song
            )
        }
    }

    // MARK: Process a chord definition

    /// Process a chord definition
    /// - Parameters:
    ///   - arguments: The directive arguments
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processDefine(
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        let label = arguments[.plain] ?? ""
        do {
            var definedChord = try ChordDefinition(
                definition: label,
                instrument: song.settings.instrument,
                status: .unknownChord
            )
            definedChord.status = song.settings.transpose == 0 ? definedChord.status : .customTransposedChord
            /// Update a standard chord with the same name if there is one in the chords list
            if let index = song.chords.firstIndex(where: {
                $0.name == definedChord.name &&
                ($0.status == .standardChord || $0.status == .transposedChord)
            }) {
                /// Use the same ID as the standard chord
                definedChord.id = song.chords[index].id
                /// Mirror if needed
                if song.settings.diagram.mirror {
                    definedChord.mirrorChordDiagram()
                }
                song.chords[index] = definedChord
            } else {
                /// Mirror if needed
                if song.settings.diagram.mirror {
                    definedChord.mirrorChordDiagram()
                }
                /// Add the chord as a new definition
                song.chords.append(definedChord)
            }
        } catch {
            /// The definition could not be processed
            currentSection.addWarning("Wrong chord definition: \(error.localizedDescription)")
        }
        addSection(
            directive: .define,
            arguments: arguments,
            currentSection: &currentSection,
            song: &song
        )
    }
}
