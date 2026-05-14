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
                    let newLine = processGrid(gridLines)
                    newSection.lines.append(newLine)
                    /// Reset the grid lines
                    /// - Note: A *grid* environment can contain more than one grid, seperated by an empty line
                    gridLines = []
                }
            }
            newSection.lines.append(line)
        }
        return newSection
    }

    /// The structure of a grid analyze
    struct GridAnalysis {
        /// Counter for required columns
        var columnsCounter: [Int]
        /// The amount of parts that are needed in a measurement
        var neededParts: Int
        /// Array with Bool if a line is playable
        var playableLine: [Bool]
    }

    /// Convert the collected grid lines into columns
    static private func processGrid(_ gridLines: [Song.Section.Line]) -> Song.Section.Line {
        /// Analize the grid
        var analysis = analyzeGrid(gridLines: gridLines)
        /// Build the columns
        var columns = buildColumns(gridLines: gridLines, analysis: &analysis)
        /// Fill the columns with parts in the correct column
        fillColumns(
            gridLines: gridLines,
            analysis: analysis,
            columns: &columns
        )
        /// Look for repeating
        resolveRepeats(columns: &columns)
        /// Look for strum patterns if the grid contains strums
        if analysis.playableLine.contains(false) {
            resolveStrumming(columns: &columns, totalLines: gridLines.count)
        }
        /// Return a new line to the section
        let newLine: Song.Section.Line = .init(type: .gridLineColumns, context: .grid, gridColumns: columns)
        return newLine
    }

    /// Analyze the grid
    /// - Parameter gridLines: The grid lines
    /// - Returns:A structure with grid analyses
    static private func analyzeGrid(gridLines: [Song.Section.Line] ) -> GridAnalysis {
        /// Find the maximimum amount of colums
        let maxColumns = gridLines
            .compactMap(\.gridsLine)
            .map(\.count)
            .max() ?? 0
        /// Create result structure
        var result = GridAnalysis(
            columnsCounter: Array(repeating: 0, count: maxColumns),
            neededParts: 0,
            playableLine: Array(repeating: false, count: gridLines.count)
        )
        /// Check the lines for the amount of cells in each column
        for (index, line) in gridLines.enumerated() where line.gridsLine != nil {
            if let grids = line.gridsLine {
                /// Check if the line is playable or if it is a strum line
                let strum = grids.flatMap(\.cells).flatMap(\.parts).map(\.content).contains(where: \.hasStrumPattern)
                result.playableLine[index] = !strum
                /// Set the maximum items for each column
                for (index, grid) in grids.enumerated() {
                    result.columnsCounter[index] = max(result.columnsCounter[index], grid.cells.flatMap(\.parts).count)
                }
            }
        }
        result.neededParts = result.columnsCounter.max() ?? 1
        return result
    }

    /// Build columns with empty parts 
    /// - Parameters:
    ///   - gridLines: The grid lines
    ///   - analysis: The analysis of the grid
    ///
    /// - Returns: Grid columns with empty parts
    static private func buildColumns(
        gridLines: [Song.Section.Line],
        analysis: inout GridAnalysis
    ) -> [Song.Section.Line.Grid] {
        /// Set how many columns we have
        var totalColumns = analysis.columnsCounter.count
        /// Create all the columns
        var columns = (0 ..< totalColumns).enumerated().map { item in
            Song.Section.Line.Grid(id: item.element)
        }
        /// Convert the the gridlines into columns
        let gridToColumns = convertGridToColumns(gridLines.compactMap(\.gridsLine))
        /// Fill the columns with the cells
        for grid in gridToColumns {
            columns[grid.id].cells.append(contentsOf: grid.cells)
        }
        /// Update the column counter with the result of the current columns
        for (columnIndex, column) in columns.enumerated() {
            let dividerColumn = column.cells.flatMap(\.parts).map(\.content).contains(where: \.hasBarLine)
            let marginColumn = column.cells.flatMap(\.parts).map(\.content).contains(where: \.isInMargin)
            if !dividerColumn && !marginColumn {
                analysis.columnsCounter[columnIndex] = analysis.neededParts
            }
        }
        /// Recreate the columns with empty parts based on the columns counter
        totalColumns = analysis.columnsCounter.reduce(0, +)
        columns = (0 ..< totalColumns).enumerated().map { item in
            let gridCell = Song.Section.Line.GridCell(id: 0, parts: [])
            return Song.Section.Line.Grid(id: item.element, cells: [gridCell])
        }
        var partID = 0
        for (index, line) in gridLines.enumerated() where line.gridsLine != nil {
            for column in 0..<totalColumns {
                let anyChord = Song.Section.Line.Part.Content.anyChord(
                    textPart: .init(),
                    beatItems: 1,
                    strum: .noStrum
                )
                let part = Song.Section.Line.Part(
                    id: partID,
                    content: analysis.playableLine[index] ? anyChord : .strum(symbol: .noStrum)
                )
                columns[column].cells[0].parts.append(part)
                partID += 1
            }
        }
        return columns
    }

    /// Fill the columns with the parts
    /// - Parameters:
    ///   - gridLines: The grid lines
    ///   - analysis: The analysis of the grid
    ///   - columns: The columns of the grid
    static private func fillColumns(
        gridLines: [Song.Section.Line],
        analysis: GridAnalysis,
        columns: inout [Song.Section.Line.Grid]
    ) {
        /// Fill the columns with parts in the correct column
        for (rowIndex, line) in gridLines.enumerated() {
            if let grids = line.gridsLine {
                var column = 0
                for (index, neededParts) in analysis.columnsCounter.enumerated() {
                    if let parts = grids[safe: index].flatMap(\.cells)?.flatMap(\.parts) {
                        for (id, part) in parts.enumerated() {
                            /// Calculate the optional shift of the part
                            let shift = calculatePartShift(
                                partID: id,
                                totalParts: parts.count,
                                neededParts: neededParts
                            )
                            var result = part
                            /// Keep the part ID of the new columns so its unique
                            result.id = columns[column + id + shift].cells[0].parts[rowIndex].id
                            if let chord = part.content.getChord {
                                result.content = .chord(
                                    definition: chord.definition,
                                    textPart: chord.textPart,
                                    beatItems: neededParts
                                )
                            }
                            columns[column + id + shift].cells[0].parts[rowIndex] = result
                        }
                    }
                    column += neededParts
                }
            }
        }

        /// Calculate the optional shift of the part
        /// - Parameters:
        ///   - partID: The ID of the part
        ///   - totalParts: The total available parts
        ///   - neededParts: The amount of parts that are needed
        func calculatePartShift(
                partID: Int,
                totalParts: Int,
                neededParts: Int
        ) -> Int {
            /// Check how many parts are missing
            let missingParts = (neededParts - totalParts)
            /// Calculate the offset
            let offset = missingParts / totalParts
            /// Calculate the shift
            /// - Note: The first part of measure will never shift
            let shift = offset == 0 || partID == 0 ? 0 : offset * partID
            /// Return the shift
            return shift
        }
    }

    /// Resolve repeats
    /// - Parameter columns: The current columns
    static private func resolveRepeats(columns: inout [Song.Section.Line.Grid]) {
        for (index, column) in columns.enumerated() {
            let parts = column.cells[0].parts
            for (row, part) in parts.enumerated() {
                if let repeating = part.content.getRepeating {
                    /// Check if we have to repeat the last *two* measures
                    var repeatLastTwoMeasures: Bool = (repeating == .repeatLastTwoMeasures)
                    var repeatingParts: [Song.Section.Line.Part] = []
                    /// Make sure we have at least 2 columns
                    guard index >= 2 else { continue }
                    for previousColumn in (0...index - 2).reversed() {
                        let part = columns[previousColumn].cells[0].parts[row]
                            if (!part.content.hasBarLine && !part.content.hasStrumPattern) || repeatLastTwoMeasures == true {
                                repeatingParts.append(part)
                                let repeatingContent = repeatingParts.map(\.content)
                                if repeatingContent.contains(where: \.hasBarLine) || repeatingContent.contains(where: \.hasStrumPattern) {
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
    }

    /// Resolve strums
    /// - Parameters:
    ///   - columns: The current columns
    ///   - totalLines: The total lines of the grid
    static private func resolveStrumming(
        columns: inout [Song.Section.Line.Grid],
        totalLines: Int
    ) {
        for (index, column) in columns.enumerated() {
            let parts = column.cells[0].parts
            for (row, part) in parts.enumerated() {
                if let strum = findNearestStrum(row: row, parts: parts, totalLines: totalLines) {
                    if var chord = part.content.getChord {
                        /// Add the strum to the chord definition
                        chord.definition.strum = strum
                        columns[index].cells[0].parts[row].content = .chord(
                            definition: chord.definition,
                            textPart: chord.textPart,
                            beatItems: chord.beatItems
                        )
                    } else {
                        /// Make sure we have at least 1 column
                        guard index >= 1 else { continue }
                        /// We have a strum but not a chord
                        for previousColumn in (0...index - 1).reversed() {
                            if let match = columns[safe: previousColumn]?.cells[0].parts[row], var chord = match.content.getChord {
                                /// Add the strum to the chord
                                chord.definition.strum = strum
                                /// Update the part
                                var part = columns[index].cells[0].parts[row]
                                part.dimmed = match.content.getChord?.definition.strum == .noStrum ? false : true
                                part.content = .chord(
                                    definition: chord.definition,
                                    textPart: chord.textPart,
                                    beatItems: chord.beatItems
                                )
                                /// Update the row with the part
                                columns[index].cells[0].parts[row] = part
                                break
                            }
                        }
                    }
                } else if var chord = part.content.getChord {
                    /// This is a chord without a strum, do not play it
                    chord.definition.strum = .noStrum
                    columns[index].cells[0].parts[row].content = .chord(
                        definition: chord.definition,
                        textPart: chord.textPart,
                        beatItems: chord.beatItems
                    )
                }
            }
        }
    }

    /// Look down to find the first optional chord strum
    /// - Parameters:
    ///   - row: The row of the chord in the grid
    ///   - parts: All parts of the column 
    ///   - totalLines: The total lines of the grid
    /// 
    /// - Returns: A strum if found, else nil
    static private func findNearestStrum(row: Int, parts: [Song.Section.Line.Part], totalLines: Int) -> Chord.Strum? {
        for index in (row + 1)..<totalLines {
            if let strum = parts[safe: index]?.content.getStrum {
                return strum
            }
        }
        return nil
    }

    /// Convert grids into columns
    /// - Parameter input: The lines
    /// - Returns: Columns
    static private func convertGridToColumns<T>(_ input: [[T]]) -> [T] {
        guard let first = input.first else { return [] }
        return (0..<first.count).flatMap { index in
            input.compactMap { $0[safe: index] }
        }
    }
}
