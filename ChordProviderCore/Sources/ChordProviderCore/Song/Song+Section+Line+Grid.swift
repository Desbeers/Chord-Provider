//
//  Song+Section+Line+Grid.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// A grid in the ``Song/Section/Line``
    public struct Grid: Identifiable, Equatable, Codable, Sendable {
        /// The unique ID of the grid
        public var id: Int
        /// The parts in the grid
        public var parts: [Part] = []
    }
}
