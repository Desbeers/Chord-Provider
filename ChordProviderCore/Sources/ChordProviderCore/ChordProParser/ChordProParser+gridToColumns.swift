//
//  ChordProParser+gridToColumns.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

extension ChordProParser {

    /// Convert grids into columns for display in GTK or PDF
    /// - Returns: A new ``Song/Section``
    public static func gridToColumns(section: Song.Section) -> Song.Section {
        var newSection = section
        newSection.lines = []
        var gridLines: [Song.Section.Line] = []
        /// Go to all the lines
        for line in section.lines {
            newSection.lines.append(line)
            if line.gridsLine != nil {
                /// Add the line to the grid lines for later processing
                gridLines.append(line)
            } else {
                if !gridLines.isEmpty {
                    processGrid()
                }
            }
        }
        return newSection

        /// Process grid lines
        func processGrid() {
            /// Make sure every part is unique
            var partID: Int = 0
            /// Check the lines for the amount of cells in each column
            var counter = Array(repeating: 0, count: 100)
            for line in gridLines where line.gridsLine != nil {
                if let grids = line.gridsLine {
                    for (index, grid) in grids.enumerated() {
                        counter[index] = max(counter[index], grid.cells.flatMap(\.parts).count)
                    }
                }
            }
            counter.removeAll {$0 == 0}
            /// Create empty columns
            var columns: [Song.Section.Line.GridCell] = (0 ..< counter.reduce(0, +)).enumerated().map { item in
                /// Create empty parts
                var parts: [Song.Section.Line.Part] = []
                for line in gridLines {
                    var part = Song.Section.Line.Part(id: partID, text: "")
                    if line.gridsLine?.compactMap(\.isStrumPattern).contains(true) ?? false {
                        part.strum = .spacer
                    } else {
                        part.chordDefinition = ChordDefinition(text: ".", kind: .textChord)
                        part.text = ""
                    }
                    partID += 1
                    parts.append(part)
                }
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
                                if let match = columns[safe: previousColumn]?.parts[row], var chord = match.chordDefinition, chord.kind != .textChord {
                                    chord.strum = strum
                                    columns[index].parts[row].text = "%"
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
            let newLine: Song.Section.Line = .init(type: .gridLineColumns, context: .grid, gridColumns: columns)
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
