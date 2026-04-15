//
//  Song+Section+Line+Grid.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// A grid in the ``Song/Section/Line``
    public struct Grid: Identifiable, Equatable, Codable, Sendable {
        public init(
            id: Int,
            isStrumPattern: Bool = false,
            cells: [GridCell] = []
        ) {
            self.id = id
            self.isStrumPattern = isStrumPattern
            self.cells = cells
        }
        /// The unique ID of the grid
        public var id: Int
        /// Bool if the grid is a strum pattern
        public var isStrumPattern: Bool
        /// The cells in the grid
        public var cells: [GridCell] = []
    }

    /// A single grid cell
    public struct GridCell: Identifiable, Equatable, Codable, Sendable {
        public init(id: Int, parts: [Song.Section.Line.Part]) {
            self.id = id
            self.parts = parts
        }
        /// The ID of the cell
        public var id: Int
        /// The parts of the cell
        public var parts: [Song.Section.Line.Part]
    }

    /// Add `grids` to a line
    /// - Parameter grid: The line with `grid` to add
    /// - Note: grids are *optionals* so we can not just 'insert' it
    mutating func addGrid(_ grid: Grid) {
        if self.grids == nil {
            self.grids = [grid]
        } else {
            self.grids?.append(grid)
        }
    }
}
