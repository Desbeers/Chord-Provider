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
        var line = Song.Section.Line(id: currentSection.lines.count + 1)
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
                let result = processChord(chord: String(text), song: &song, ignoreUnknown: true)
                if result.status == .unknownChord {
                    grid.parts.append(Song.Section.Line.Part(id: partID, chord: nil, text: text))
                } else {
                    grid.parts.append(Song.Section.Line.Part(id: partID, chord: result.id))
                }
            }
            partID += 1
            line.grid.append(grid)
        }
        currentSection.lines.append(line)
        /// Mark the section as Grid if not set
        if currentSection.type == .none {
            currentSection.type = .grid
            currentSection.label = ChordPro.Environment.grid.rawValue
            song.log.append(.init(type: .warning, lineNumber: song.lines, message: "No environment set, assuming Grid"))
        }
    }
}
