//
//  Song+Section+gridColumns.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section {

    /// Convert grids into columns for display in GTK or PDF
    /// - Returns: A new ``Song/Section``
    public func gridColumns() -> Song.Section {
        var newSection = self
        newSection.lines = []

        var gridLines: [Song.Section.Line] = []

        for line in self.lines {
            if line.grids != nil {
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
            for line in gridLines where line.grids != nil {
                if let grids = line.grids {
                    for (index, grid) in grids.enumerated() {
                        counter[index] = max(counter[index], grid.cells.flatMap(\.parts).count)
                    }
                }
            }
            counter.removeAll {$0 == 0}
            if let max = counter.max() {
                counter = Array(repeating: max, count: counter.count)
            }
            /// Create empty parts
            var parts: [Song.Section.Line.Part] = []
            for index in gridLines.enumerated() {
                parts.append(.init(id: index.offset, text: ""))
            }
            /// Create an empty grid cell
            let cell = Song.Section.Line.GridCell(
                id: 0,
                parts: parts
            )
            /// Create empty columns
            var columns: [Song.Section.Line.Grid] = (0 ..< counter.reduce(0, +)).enumerated().map { item in
                return Song.Section.Line.Grid(id: item.element, cells: [cell])
            }
            /// Fill the columns
            for (row, line) in gridLines.enumerated() {
                if let grids = line.grids {
                    var column = 0
                    for (index, items) in counter.enumerated() {
                        if let parts = grids[safe: index].flatMap(\.cells)?.flatMap(\.parts) {
                            let offset = (items / parts.count) - 1
                            for (id, part) in parts.enumerated() {
                                let shift = offset == 0 || id == 0 ? 0 : offset * id
                                var part = part
                                part.cells = items
                                columns[column + id + shift].cells[0].parts[row] = part
                            }
                        }
                        column += items
                    }
                }
            }

            /// Look for strum patterns
            for (index, column) in columns.enumerated() {
                let parts = column.cells.flatMap(\.parts)
                let strums = parts.filter { $0.strum != nil }.filter { $0.strum != Chord.Strum.none }
                for (row, part) in parts.enumerated() {
                    if !strums.isEmpty, let strum = nearestPart(to: row, in: strums) {
                        if part.chordDefinition != nil {
                            columns[index].cells[0].parts[row].chordDefinition?.strum = strum.strum
                        //}
                        } else if part.text == "." || part.text == "" {
                            if let item = columns[safe: index - 1]?.cells[0].parts[safe: row], var chord = item.chordDefinition {
                                chord.strum = strum.strum
                                columns[index].cells[0].parts[row].text = nil
                                columns[index].cells[0].parts[row].hidden = true
                                columns[index].cells[0].parts[row].chordDefinition = chord
                            }
                        }
                    }                    
                }
            }

            /// Add a new line to the section
            var newLine: Song.Section.Line = .init(type: .songLine)
            newLine.grids = columns
            newSection.lines.append(newLine)
            /// Reset the lines
            gridLines = []
        }

        func nearestPart(to id: Int, in parts: [Song.Section.Line.Part]) -> Song.Section.Line.Part? {
            return parts.min {
                abs($0.id - id) < abs($1.id - id)
            }
        }
    }
}
