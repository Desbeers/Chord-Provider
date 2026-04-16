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
        var cellID: Int = 0
        var partID: Int = 0
        /// The optional omitted symbol
        var omittedSymbol: String?
        /// Bool if the line is a strum pattern
        var isStrumPattern: Bool = false
        /// Separate the grids
        var grids = text.matches(of: RegexDefinitions.gridSeparator).map { match in
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
            let markup = text.markup(handleBrackets: true)
            /// Use the plain text only
            let text = markup.text
            switch text {
                //case "|", "||", " ", ".":
            case "|", "||", " ":
                let part = Song.Section.Line.Part(
                    id: partID,
                    text: omittedSymbol ?? text,
                    strum: .spacer
                )
                grid.cells.append(Song.Section.Line.GridCell(id: cellID, parts: [part]))
                cellID += 1
                partID += 1
            default:
                var parts: [Song.Section.Line.Part] = []
                /// Multiple chords can be put in a single cell by separating the chord names with a ~ (tilde)
                let chords = text.split(separator: "~")
                for text in chords {
                    if text.starts(with: "*") {
                        /// Insert as a string
                        let string = String(text.dropFirst())
                        parts.append(
                            Song.Section.Line.Part(
                                id: partID,
                                text: string,
                                strum: isStrumPattern ? .spacer : nil
                            )
                        )
                    } else {
                        switch isStrumPattern {
                        case true:
                            /// Try to get the strum definition
                            if let strum = Chord.strumCharacterDict[String(text)] {
                                parts.append(
                                    Song.Section.Line.Part(
                                        id: partID,
                                        strum: strum
                                    )
                                )
                            } else {
                                /// Unknown strum; fill the space and add a warning
                                parts.append(
                                    Song.Section.Line.Part(
                                        id: partID,
                                        text: "?"
                                    )
                                )
                                line.addWarning("Unknown strum: <b>\(text)</b>", level: .error)
                            }
                        case false:
                            if text == "." {
                                /// Do not play a chord here
                                /// Add it as a text chord
                                let result = ChordDefinition(
                                    text: String(text),
                                    //text: "SKIP",
                                    kind: .textChord
                                )
                                parts.append(
                                    Song.Section.Line.Part(
                                        id: partID,
                                        chordDefinition: result,
                                        text: String(text)
                                    )
                                )
                            } else {
                                let result = processChord(
                                    chord: String(text),
                                    line: &line,
                                    song: &song,
                                )
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
                grid.cells.append(Song.Section.Line.GridCell(id: cellID, parts: parts))
                cellID += 1
            }
            // cellID += 1
            // partID += 1
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

extension ChordProParser {

    /// Convert grids into columns for display in GTK or PDF
    /// - Returns: A new ``Song/Section``
    public static func gridToColumns(section: Song.Section) -> Song.Section {
        var newSection = section
        newSection.lines = []

        var gridLines: [Song.Section.Line] = []

        for line in section.lines {
            if line.gridsLine != nil {
                gridLines.append(line)
            } else {
                if !gridLines.isEmpty {
                    processGrid()
                }
                newSection.lines.append(line)
            }
        }

        return newSection

        func processGrid() {
            var counter = Array(repeating: 0, count: 100)
            for line in gridLines where line.gridsLine != nil {
                if let grids = line.gridsLine {
                    for (index, grid) in grids.enumerated() {
                        counter[index] = max(counter[index], grid.cells.flatMap(\.parts).count)
                    }
                }
            }
            counter.removeAll {$0 == 0}
            // if let max = counter.max() {
            //     counter = Array(repeating: max, count: counter.count)
            // }
            /// Create empty parts
            var parts: [Song.Section.Line.Part] = []
            for (index, line) in gridLines.enumerated() {
                var part = Song.Section.Line.Part(id: index, text: "")
                if line.gridsLine?.compactMap(\.isStrumPattern).contains(true) ?? false {
                    part.strum = .spacer
                } else {
                    part.chordDefinition = ChordDefinition(text: ".", kind: .textChord)
                    part.text = ""
                }
                parts.append(part)
            }
            // /// Create an empty grid cell
            // /// - Note: The ID will always be 0 because it is fattend
            // var cell = Song.Section.Line.GridCell(
            //     id: 0,
            //     parts: parts
            // )
            /// Create empty columns
            var columns: [Song.Section.Line.GridCell] = (0 ..< counter.reduce(0, +)).enumerated().map { item in
                return Song.Section.Line.GridCell(id: item.element, parts: parts)
            }
            /// Fill the columns
            for (row, line) in gridLines.enumerated() {
                if let grids = line.gridsLine {
                    var column = 0
                    for (index, items) in counter.enumerated() {
                        if let parts = grids[safe: index].flatMap(\.cells)?.flatMap(\.parts) {
                            let offset = (items / parts.count) - 1
                            for (id, part) in parts.enumerated() {
                                let shift = offset == 0 || id == 0 ? 0 : offset * id
                                var result = part
                                /// Keep the part ID of the new columns
                                result.id = columns[column + id + shift].parts[row].id
                                result.cells = items
                                columns[column + id + shift].parts[row] = result
                            }
                        }
                        column += items
                    }
                }
            }

            /// Look for strum patterns
            for (index, column) in columns.enumerated() {
                let parts = column.parts
                for (row, part) in parts.enumerated() {
                    if let strum = nearestStum(row: row, parts: parts) {
                    //if let strum = parts[safe: row - 1]?.strum ?? parts[safe: row + 1]?.strum, strum != Chord.Strum.none, strum != Chord.Strum.spacer {
                        if part.chordDefinition != nil, part.chordDefinition?.kind != .textChord {
                            /// Add the strum to the chord definition
                            columns[index].parts[row].chordDefinition?.strum = strum
                        } else if part.strum == nil {
                            /// We have a strum but not a chord. Fill-in the nearest last chord on the left
                            for previousColumn in (0...index - 1).reversed() {
                                if let match = columns[safe: previousColumn]?.parts[row], var chord = match.chordDefinition, chord.knownChord {
                                    chord.strum = strum
                                    columns[index].parts[row].text = nil
                                    columns[index].parts[row].hidden = true
                                    columns[index].parts[row].chordDefinition = chord
                                    break
                                }
                            }
                        
                        }
                    }                
                }
            }
            /// Add a new line to the section
            let newLine: Song.Section.Line = .init(type: .songLine, grids: columns)
            newSection.lines.append(newLine)
            /// Reset the lines
            gridLines = []
        }

        func nearestStum(row: Int, parts: [Song.Section.Line.Part]) -> Chord.Strum? {
            /// Look above
            if let strum = parts[safe: row - 1]?.strum, Chord.Strum.options.contains(strum) {
                return strum
            }
            /// Look below
            if let strum = parts[safe: row + 1]?.strum, Chord.Strum.options.contains(strum) {
                return strum
            }
            /// No strum found
            return nil
        }
    }
}