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

        /// Convert the collected grid lines into columns
        func processGrid() {
            /// The counter for columns
            /// - Note: I go for a lot of columns but will clear afterwards
            var columnsCounter: [Int] = Array(repeating: 0, count: 100)
            /// Bool if a line contains playable items
            /// - Note: Those are lines with chords, this is later used to fill-in undefined chords
            var playableLine: [Bool] = Array(repeating: false, count: gridLines.count)
            /// Check the lines for the amount of cells in each column
            for (index, line) in gridLines.enumerated() where line.gridsLine != nil {
                if let grids = line.gridsLine {
                    /// Check if the line is playable or if it is a strum line
                    let strum = grids.flatMap(\.cells).flatMap(\.parts).compactMap(\.strum).compactMap(\.strumPattern)
                    playableLine[index] = strum.isEmpty ? true : false
                    /// Set the maximum items for each column
                    for (index, grid) in grids.enumerated() {
                        columnsCounter[index] = max(columnsCounter[index], grid.cells.flatMap(\.parts).count)
                    }
                }
            }
            /// Clear the empty columns from the counter
            columnsCounter.removeAll {$0 == 0}
            /// Set how many columns we have
            var totalColumns = columnsCounter.count
            /// Find how many parts each column should have
            /// - Note: An *optional* but this should not fail
            let neededParts = columnsCounter.max() ?? 1
            /// Create all the columns
            var columns = (0 ..< totalColumns).enumerated().map { item in
                Song.Section.Line.Grid(id: item.element)
            }
            /// Convert the the gridlines into columns
            let gridToColumns = gridToColumns(gridLines.compactMap(\.gridsLine))
            /// Fill the columns with the cells
            for grid in gridToColumns {
                columns[grid.id].cells.append(contentsOf: grid.cells)
            }
            /// Update the column counter
            for (columnIndex, column) in columns.enumerated() {
                let dividerColumn = column.cells.flatMap(\.parts).compactMap(\.strum).compactMap(\.barLineSymbol)
                let marginColumn = column.cells.flatMap(\.parts).compactMap(\.strum).compactMap(\.isInMargin)
                if dividerColumn.isEmpty && marginColumn.isEmpty {
                    columnsCounter[columnIndex] = neededParts
                }
            }

            /// Update the columns with empty parts
            totalColumns = columnsCounter.reduce(0, +)
            columns = (0 ..< totalColumns).enumerated().map { item in
                let gridCell = Song.Section.Line.GridCell(id: 0, parts: [])
                return Song.Section.Line.Grid(id: item.element, cells: [gridCell])
            }
            var partID = 0
            for (index, line) in gridLines.enumerated() where line.gridsLine != nil {
                for column in 0..<totalColumns {
                    var chord = ChordDefinition(text: "", kind: .textChord)
                    chord.strum = .noStrum
                    let part = Song.Section.Line.Part(
                        id: partID,
                        chordDefinition: playableLine[index] == true ? chord : nil,
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
                    for (index, neededParts) in columnsCounter.enumerated() {
                        if let parts = grids[safe: index].flatMap(\.cells)?.flatMap(\.parts) {
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

            /// Look for repeating
            for (index, column) in columns.enumerated() {
                let parts = column.cells[0].parts
                for (row, part) in parts.enumerated() {
                    if let repeating = part.strum?.repeatingSymbol {
                        var repeatLastTwoMeasures: Bool = repeating == .repeatLastTwoMeasures ? true : false
                        var repeatingParts: [Song.Section.Line.Part] = []
                        for previousColumn in (0...index - 2).reversed() {
                            let part = columns[previousColumn].cells[0].parts[row]
                                if (part.strum?.barLineSymbol == nil && part.strum?.strumPattern == nil) || repeatLastTwoMeasures == true {
                                    repeatingParts.append(part)
                                    let strum = repeatingParts.compactMap(\.strum)
                                    if !strum.compactMap(\.barLineSymbol).isEmpty || !strum.compactMap(\.strumPattern).isEmpty {
                                        repeatLastTwoMeasures = false
                                    }
                                } else {
                                    break
                                }
                        }
                        if !repeatingParts.isEmpty {
                            for (updateColumn, part) in repeatingParts.reversed().enumerated() {
                                var part = part
                                part.id = columns[index + updateColumn].cells[0].parts[row].id
                                columns[index + updateColumn].cells[0].parts[row] = part
                            }
                        }
                    }
                }
            }

            /// Look for strum patterns
            if playableLine.contains(false) {
                for (index, column) in columns.enumerated() {
                    let parts = column.cells[0].parts
                    for (row, part) in parts.enumerated() {
                        if let strum = findNearestStum(row: row, parts: parts) {
                            if part.chordDefinition != nil, part.chordDefinition?.kind != .textChord {
                                /// Add the strum to the chord definition
                                columns[index].cells[0].parts[row].chordDefinition?.strum = strum
                            } else {
                                /// We have a strum but not a chord
                                for previousColumn in (0...index - 1).reversed() {
                                    if let match = columns[safe: previousColumn]?.cells[0].parts[row], var chord = match.chordDefinition, chord.kind != .textChord {
                                        /// Add the strum to the chord
                                        chord.strum = strum
                                        /// Update the part
                                        var part = columns[index].cells[0].parts[row]
                                        part.chordMarkup = match.chordMarkup
                                        part.hidden = match.chordDefinition?.strum == .noStrum ? false : true
                                        part.chordDefinition = chord
                                        part.strum = match.strum
                                        /// Update the row with the part
                                        columns[index].cells[0].parts[row] = part
                                        break
                                    }
                                }
                            }
                        } else if let chord = part.chordDefinition, chord.knownChord {
                            /// This is a chord without a strum, do not play it
                            columns[index].cells[0].parts[row].chordDefinition?.strum = .noStrum
                        }         
                    }
                }
            }
            /// Add a new line to the section
            let newLine: Song.Section.Line = .init(type: .gridLineColumns, context: .grid, gridColumns: columns)
            newSection.lines.append(newLine)
            /// Reset the grid lines
            /// - Note: A *grid* environment can contain more than one grid, seperated by an empty line
            gridLines = []
        }

        /// Look down to find the first optional chord strum
        /// - Parameters:
        ///   - row: The row of the chord in the grid
        ///   - parts: All parts of the column 
        ///
        /// - Returns: A strum if found, else nil
        func findNearestStum(row: Int, parts: [Song.Section.Line.Part]) -> Chord.Strum? {
            let rows = gridLines.count
            for index in row..<rows {
                if let strum = parts[safe: index + 1]?.strum?.strum {
                    return strum
                }
            }
            return nil
        }

        /// Convert lines into columns
        /// - Parameter input: The lines
        /// - Returns: Columns
        func gridToColumns<T>(_ input: [[T]]) -> [T] {
            guard let first = input.first else { return [] }
            return (0..<first.count).flatMap { index in
                input.compactMap { $0[safe: index] }
            }
        }
    }
}
