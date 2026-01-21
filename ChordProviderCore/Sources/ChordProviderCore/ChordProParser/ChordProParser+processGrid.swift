//
//  ChordProParser+processGrid.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation
import RegexBuilder

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
        var cellID: Int = 1
        var partID: Int = 1
        /// The optional omitted symbol
        var omittedSymbol: String?
        /// Bool if the line is a strum pattern
        var isStrumPattern: Bool = false
        /// Separate the grids
        var grids = text.matches(of: ChordPro.RegexDefinitions.gridSeparator).map { match in
            String(match.0)
        }
        /// Check if the grid line is a strum pattern
        if grids.first == "|S" {
            grids[0] = "|"
            isStrumPattern = true
        }
        if grids.first == "|s" {
            /// The bar symbols and cell lines will be omitted
            omittedSymbol = " "
            grids[0] = "|"
            isStrumPattern = true
        }
        /// Check if there is a space at the beginning
        if text.starts(with: " ") {
            /// Insert a spacer
            grids.insert(" ", at: 0)
        }
        for text in grids where !text.isEmpty {
            var grid = Song.Section.Line.Grid(id: cellID, isStrumPattern: isStrumPattern)
            /// Check for pango markup
            let markup = text.markup
            /// Use the plain text only
            let text = markup.text
            switch text {
            case "|", " ":
                let part = Song.Section.Line.Part(id: partID, text: omittedSymbol ?? text)
                grid.cells.append(Song.Section.Line.GridCell(id: partID, parts: [part]))
            default:
                var parts: [Song.Section.Line.Part] = []
                /// Multiple chords can be put in a single cell by separating the chord names with a ~ (tilde)
                let chords = text.split(separator: "~")
                for text in chords {
                    if text.starts(with: "*") {
                        /// Insert as a string
                        let string = String(text.dropFirst())
                        parts.append(Song.Section.Line.Part(id: partID, text: string))
                    } else {
                        switch isStrumPattern {
                        case true:
                            /// Try to get the strum definition
                            if let strum = Song.Section.Line.strumCharacterDict[String(text)] {
                                parts.append(
                                    Song.Section.Line.Part(
                                        id: partID,
                                        strum: strum
                                    )
                                )
                            } else {
                                /// Unknown strum; fill the space and add a warning
                                let chord = ChordDefinition(text: "?", instrument: song.settings.instrument)
                                parts.append(Song.Section.Line.Part(id: partID, chordDefinition: chord, text: chord.display))
                                line.addWarning("Unknown stroke", level: .error)
                            }
                        case false:
                            let result = processChord(
                                chord: String(text),
                                line: &line,
                                song: &song,
                                warning: false
                            )
                            if result.status == .unknownChord {
                                parts.append(Song.Section.Line.Part(id: partID, text: String(text), textMarkup: markup))
                            } else {
                                parts.append(
                                    Song.Section.Line.Part(
                                        id: partID,
                                        chordDefinition: result,
                                        text: result.display,
                                        chordMarkup: markup
                                    )
                                )
                            }
                        }
                    }
                    partID += 1
                }
                grid.cells.append(Song.Section.Line.GridCell(id: partID, parts: parts))
            }
            cellID += 1
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
