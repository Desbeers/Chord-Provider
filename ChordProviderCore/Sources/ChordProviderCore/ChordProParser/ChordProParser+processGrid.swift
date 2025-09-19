//
//  ChordProParser+processGrid.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a grid environment

    /// Process a grid environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processGrid(
        text: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        /// Start with a fresh line:
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            source: text,
            sourceParsed: text.trimmingCharacters(in: .whitespaces),
            type: .songLine,
            context: .grid
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
                grid.parts.append(Song.Section.Line.Part(id: partID, text: text))
            default:
                let result = processChord(
                    chord: String(text),
                    line: &line,
                    song: &song
                )
                if result.status == .unknownChord {
                    grid.parts.append(Song.Section.Line.Part(id: partID, text: text))
                } else {
                    grid.parts.append(
                        Song.Section.Line.Part(
                            id: partID,
                            chordDefinition: result,
                            text: result.display
                        )
                    )
                }
            }
            partID += 1
            line.addGrid(grid)
        }
        /// Set the context
        line.context = currentSection.environment
        /// Add the line"
        currentSection.lines.append(line)
        /// Mark the section as Grid if not set
        if currentSection.environment == .none {
            autoSection(
                environment: .grid,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
