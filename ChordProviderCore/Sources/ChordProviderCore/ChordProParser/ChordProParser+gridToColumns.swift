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
            if line.gridsLine != nil {
                /// Add the line to the grid lines for later processing
                gridLines.append(line)
            } else {
                if !gridLines.isEmpty {
                    processGrid()
                }
            }
            newSection.lines.append(line)
        }
        return newSection

        func processGrid() {
            /// The counter for columns
            var columnCounter: [Int] = Array(repeating: 0, count: 100)
            /// Bool if a line contains playable items
            var playableLine: [Bool] = Array(repeating: false, count: gridLines.count)
            /// Check the lines for the amount of cells in each column
            for (index, line) in gridLines.enumerated() where line.gridsLine != nil {
                if let grids = line.gridsLine {
                    /// Check if the line is playable or if it is a strum line
                    let strum = grids.flatMap(\.cells).flatMap(\.parts).compactMap(\.strum).compactMap(\.strumPattern)
                    playableLine[index] = strum.isEmpty ? true : false
                    /// Set the maximum items for each column
                    for (index, grid) in grids.enumerated() {
                        columnCounter[index] = max(columnCounter[index], grid.cells.flatMap(\.parts).count)
                    }
                }
            }
            /// Clear the empty columns
            columnCounter.removeAll {$0 == 0}

            
            var totalColumns = columnCounter.count

            let neededParts = columnCounter.max() ?? 1
            /// Create columns
            var columns = (0 ..< totalColumns).enumerated().map { item in
                Song.Section.Line.Grid(id: item.element)
            }

            let gridToColumns = interleave(gridLines.compactMap(\.gridsLine))

            for grid in gridToColumns {
                columns[grid.id].cells.append(contentsOf: grid.cells)
            }
            for (columnIndex, column) in columns.enumerated() {
                let dividerColumn = column.cells.flatMap(\.parts).compactMap(\.strum).compactMap(\.barLineSymbol)
                if dividerColumn.isEmpty {
                    columnCounter[columnIndex] = neededParts
                }
            }

            /// Update the columns
            totalColumns = columnCounter.reduce(0, +)
            columns = (0 ..< totalColumns).enumerated().map { item in
                let gridCell = Song.Section.Line.GridCell(id: 0, parts: [])
                return Song.Section.Line.Grid(id: item.element, cells: [gridCell])
            }
            var partID = 0
            for (index, line) in gridLines.enumerated() where line.gridsLine != nil {
                for column in 0..<totalColumns {
                    var chord = ChordDefinition(text: ".", kind: .textChord)
                    chord.strum = .noStrum
                    let part = Song.Section.Line.Part(
                        id: partID,
                        chordDefinition: playableLine[index] == true ? chord : nil,
                        //text: playableLine[index] == true  ? "." : " ",
                        strum: .init(beatItems: neededParts)
                    )
                    columns[column].cells[0].parts.append(part)
                    partID += 1
                }
            }
            /// Fill the columns with parts in the correct column
            for (rowIndex, line) in gridLines.enumerated() {
                if let grids = line.gridsLine {
                    var column = 0
                    for (index, neededParts) in columnCounter.enumerated() {
                        if let parts = grids[safe: index].flatMap(\.cells)?.flatMap(\.parts) {
                            // let offset = (neededParts / parts.count) - 1
                            let missingParts = (neededParts - parts.count)
                            let offset = missingParts / parts.count
                            for (id, part) in parts.enumerated() {
                                let shift = offset == 0 || id == 0 ? 0 : offset * id
                                var result = part
                                /// Keep the part ID of the new columns so its unique
                                result.id = columns[column + id + shift].cells[0].parts[rowIndex].id
                                if part.chordDefinition != nil {
                                    result.strum = .init(beatItems: neededParts)
                                }
                                columns[column + id + shift].cells[0].parts[rowIndex] = result
                            }
                        }
                        column += neededParts
                    }
                }
            }

            /// Look for strum patterns
            if playableLine.contains(false) {
                for (index, column) in columns.enumerated() {
                    let parts = column.cells[0].parts
                    for (row, part) in parts.enumerated() {
                        if let strum = nearestStum(row: row, parts: parts) {
                            if part.chordDefinition != nil, part.chordDefinition?.kind != .textChord {
                                /// Add the strum to the chord definition
                                columns[index].cells[0].parts[row].chordDefinition?.strum = strum
                            } else {
                                /// We have a strum but not a chord. Fill-in the nearest last chord on the left
                                for previousColumn in (0...index - 1).reversed() {
                                    if let match = columns[safe: previousColumn]?.cells[0].parts[row], var chord = match.chordDefinition, chord.kind != .textChord {
                                        chord.strum = strum
                                        columns[index].cells[0].parts[row].chordMarkup = match.chordMarkup
                                        columns[index].cells[0].parts[row].hidden = match.chordDefinition?.strum == .noStrum ? false : true
                                        columns[index].cells[0].parts[row].chordDefinition = chord
                                        columns[index].cells[0].parts[row].strum = match.strum
                                        break
                                    }
                                }
                            
                            }
                        } else if let chord = part.chordDefinition, chord.knownChord {
                            /// Chord without strum, do not play
                            columns[index].cells[0].parts[row].chordDefinition?.strum = .noStrum
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
            // if let strum = parts[safe: row - 1]?.strum?.strum, Chord.Strum.options.contains(strum) {
            //     return strum
            // }
            /// Look below
            if let strum = parts[safe: row + 1]?.strum?.strum, Chord.Strum.options.contains(strum) {
                return strum
            }
            /// No strum found
            return nil
        }

        func interleave<T>(_ input: [[T]]) -> [T] {
            guard let first = input.first else { return [] }
            return (0..<first.count).flatMap { index in
                input.compactMap { $0[safe: index] }
            }
        }
    }
}
