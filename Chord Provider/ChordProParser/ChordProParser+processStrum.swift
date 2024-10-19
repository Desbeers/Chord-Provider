//
//  ChordProParser+processStrum.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a strum environment

    /// Process a strum environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    static func processStrum(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line
        var line = Song.Section.Line(id: currentSection.lines.count + 1)

        var pattern = ""
        var bottom = ""

        for(index, character) in text.trimmingCharacters(in: .whitespacesAndNewlines).enumerated() {
            let value = Song.Section.Line.strumCharacterDict[String(character)]
            pattern += value ?? String(character)
            if (index % 2) == 0 {
                bottom += "=="
            } else {
                pattern += " "
                bottom += " "
            }
        }
        line.strum.append(pattern)
        line.strum.append(bottom)
        currentSection.lines.append(line)
    }
}
