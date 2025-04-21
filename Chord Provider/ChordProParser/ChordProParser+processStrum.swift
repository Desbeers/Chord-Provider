//
//  ChordProParser+processStrum.swift
//  Chord Provider
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
            environment: .strum,
            directive: .environmentLine,
            source: text
        )

        var result: [[Song.Section.Line.Strum]] = []

        for(index, character) in text.trimmingCharacters(in: .whitespacesAndNewlines).enumerated() {
            let value = Song.Section.Line.strumCharacterDict[String(character)]
            var strum = Song.Section.Line.Strum()
            strum.id = index
            strum.strum = value ?? String(character)

            if index % tuplet == 0 {
                beat = beat == timeSignature ? 1 : beat + 1
                strum.beat = "\(beat)"
                group += 1
            } else {
                strum.tuplet = "﹠"
                group += 1
            }
            strums.append(strum)

            if timeSignature * tuplet == group {
                result.append(strums)
                strums = []
                group = 0
            }
        }
        line.strum = result
        currentSection.lines.append(line)
    }
}
