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
        public init(id: Int, parts: [Song.Section.Line.Part] = []) {
            self.id = id
            self.parts = parts
        }
        /// The unique ID of the grid
        public var id: Int
        /// The parts in the grid
        public var parts: [Part] = []
    }
}

extension Song.Section.Line {

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
}
