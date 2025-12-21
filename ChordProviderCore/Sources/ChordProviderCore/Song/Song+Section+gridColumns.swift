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
        /// Give all parts an unique id
        var partID: Int = 1
        /// Get the maximum columns
        let maxColumns = self.lines.compactMap { $0.grid }.reduce(0) { accumulator, grids in
            let elements = grids.flatMap { $0.cells }.count
            return max(accumulator, elements)
        }
        var elements: [Song.Section.Line.Grid] = (0 ..< maxColumns).enumerated().map { item in
            Song.Section.Line.Grid(id: item.element)
        }
        for line in self.lines {
            if let grid = line.grid {
                let parts = grid.flatMap { $0.cells }
                for (column, part) in parts.enumerated() {
                    var part = part
                    part.id = partID
                    elements[column].cells.append(part)
                    partID += 1
                }
                /// Fill the grid if needed
                if parts.count < maxColumns {

                    for column in (parts.count..<maxColumns) {
                        let cell = Song.Section.Line.GridCell(id: partID, parts: [Song.Section.Line.Part(id: partID, text: "")])

                        elements[column].cells.append(cell)
                        partID += 1
                    }
                }
            } else {
                if  let first = elements.first, !first.cells.isEmpty {
                    /// Add this as item
                    var newLine: Song.Section.Line = .init(type: .songLine)
                    newLine.gridColumns = Song.Section.Line.GridColumns(id: line.sourceLineNumber, grids: elements)
                    newSection.lines.append(newLine)
                    /// Clear the grid
                    elements = (0 ..< maxColumns).enumerated().map { item in
                        Song.Section.Line.Grid(id: item.element)
                    }
                }
                /// Add the other line
                newSection.lines.append(line)
            }
        }
        return newSection
    }
}
