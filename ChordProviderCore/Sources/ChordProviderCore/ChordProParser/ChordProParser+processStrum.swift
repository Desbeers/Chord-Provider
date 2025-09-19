//
//  ChordProParser+processStrum.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a strum environment

    /// Process a strum environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processStrum(
        text: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        let tuplet = Int(currentSection.arguments?[.tuplet] ?? "1") ?? 1
        let timeSignature = (Int(song.metadata.time?.prefix(1) ?? "4") ?? 4)
        var beat = 0
        var group = 0
        var strums: [Song.Section.Line.Strum] = []

        /// Start with a fresh line
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            source: text,
            sourceParsed: text.trimmingCharacters(in: .whitespaces),
            type: .songLine,
            context: .strum
        )

        var result: [[Song.Section.Line.Strum]] = []
        let parts = text.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
        for(index, character) in parts.enumerated() {

            let value = Song.Section.Line.strumCharacterDict[String(character)]
            var strum = Song.Section.Line.Strum()
            strum.id = index
            strum.action = value ?? .none

            if index % tuplet == 0 {
                beat = beat == timeSignature ? 1 : beat + 1
                strum.beat = "\(beat)"
            }
            group += 1
            strums.append(strum)

            if timeSignature * tuplet == group {
                result.append(strums)
                strums = []
                group = 0
            }
        }
        if !strums.isEmpty {
            result.append(strums)
        }
        if strums.count == 1, strums.first?.action == Song.Section.Line.Strum.Action.none {
            /// It looks like the strum is not in a valid format, add a warning
            line.addWarning("The strum pattern does not look valid")
        } else {
            line.strum = result
        }
        currentSection.lines.append(line)
    }
}
