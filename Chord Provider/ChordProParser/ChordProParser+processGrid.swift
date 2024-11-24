//
//  ChordProParser+processGrid.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a grid environment

    /// Process a grid environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    static func processGrid(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line:
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            environment: .grid,
            directive: .environmentLine,
            source: text
        )
        /// Give the structs an ID
        var partID: Int = 1
        /// Separate the grids
        let grids = text.split(separator: " ")
        for text in grids where !text.isEmpty {
            let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            var grid = Song.Section.Line.Grid(id: partID)
            switch text {
            case "|", ".":
                grid.parts.append(Song.Section.Line.Part(id: partID, chord: nil, text: text))
            default:
                let result = processChord(
                    chord: String(text),
                    line: &line,
                    song: &song,
                    ignoreUnknown: true
                )
                if result.status == .unknownChord {
                    grid.parts.append(Song.Section.Line.Part(id: partID, chord: nil, text: text))
                } else {
                    grid.parts.append(Song.Section.Line.Part(id: partID, chord: result.id))
                }
            }
            partID += 1
            line.addGrid(grid)
        }
        /// Mark the section as Grid if not set
        if currentSection.environment == .none {
            line.addWarning(
                autoSection(
                    environment: .grid,
                    currentSection: &currentSection,
                    song: &song
                )
            )
        }
        currentSection.lines.append(line)
    }
}
