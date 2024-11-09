//
//  ChordProParser+processLine.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a line

    /// Process a line
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    static func processLine(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line:
        var line = Song.Section.Line(id: currentSection.lines.count + 1)
        var partID: Int = 1

        var matches = text.matches(of: RegexDefinitions.line)
        /// The last match is the newline character so completely empty; we don't need it
        matches = matches.dropLast()
        for match in matches {
            let (_, chord, lyric) = match.output
            var part = Song.Section.Line.Part(id: partID)
            if let chord {
                part.chord = processChord(chord: String(chord), song: &song).id
                part.text = " "
                /// Because it has a chord; it should be at least a verse
                if currentSection.type == .none {
                    currentSection.type = .verse
                    currentSection.label = ChordPro.Environment.verse.rawValue
                    currentSection.autoCreated = true
                    song.log.append(.init(type: .warning, lineNumber: song.lines, message: "No environment set, assuming Verse"))
                }
            }
            if let lyric {
                part.text = String(lyric)
            }
            if !(part.empty) {
                partID += 1
                line.parts.append(part)
            }
        }
        currentSection.lines.append(line)
    }
}
