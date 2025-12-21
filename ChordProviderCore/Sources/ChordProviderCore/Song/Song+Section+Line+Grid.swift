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
        public init(id: Int, isStrumPattern: Bool = false, cells: [GridCell] = []) {
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
        public var id: Int
        public var parts: [Song.Section.Line.Part]
    }

    /// Grid columns in the ``Song/Section/Line``
    public struct GridColumns: Identifiable, Equatable, Codable, Sendable {
        public init(id: Int, grids: [Song.Section.Line.Grid] = []) {
            self.id = id
            self.grids = grids
        }
        /// The unique ID of the grid
        public var id: Int
        /// The parts in the grid
        public var grids: [Song.Section.Line.Grid] = []
    }

    /// Add `grid` to a line
    /// - Parameter grid: The line with `grid` to add
    /// - Note: grids are *optionals* so we can not just 'insert' it
    mutating func addGrid(_ grid: Grid) {
        if self.grid == nil {
            self.grid = [grid]
        } else {
            self.grid?.append(grid)
        }
    }
}
