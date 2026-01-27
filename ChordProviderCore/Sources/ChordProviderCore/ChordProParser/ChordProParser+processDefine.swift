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
    ///   - directive: The directive
    ///   - arguments: The directive arguments
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processDefine(
        instrument: Chord.Instrument,
        directive: ChordPro.Directive,
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        if song.settings.instrument == instrument {
            processDefine(
                directive: directive,
                arguments: arguments,
                currentSection: &currentSection,
                song: &song
            )
        } else {
            /// The definition is for another instrument
            currentSection.addWarning(
                "The chord definition is for <b>\(instrument.rawValue)</b> and will be ignored",
                level: .notice
            )
            addSection(
                directive: directive,
                arguments: arguments,
                currentSection: &currentSection,
                song: &song
            )
        }
    }

    // MARK: Process a chord definition

    /// Process a chord definition
    /// - Parameters:
    ///   - directive: The directive
    ///   - arguments: The directive arguments
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    private static func processDefine(
        directive: ChordPro.Directive,
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        let label = arguments[.plain] ?? ""
        do {
            var definedChord = try ChordDefinition(
                definition: label,
                kind: .customChord,
                instrument: song.settings.instrument
            )
            if song.transposing != 0 {
                /// Transpose the chord; this will disable diagrams
                definedChord.transpose(transpose: song.transposing, scale: song.metadata.key?.root ?? .c)
            }
            /// Add the chord as a new definition
            song.chords.append(definedChord)
        } catch {
            /// The definition could not be processed
            currentSection.addWarning(
                "Wrong chord definition: <b>\(error.localizedDescription)</b>",
                level: .error
            )
        }
        addSection(
            directive: directive,
            arguments: arguments,
            currentSection: &currentSection,
            song: &song
        )
    }
}
