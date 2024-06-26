//
//  Song+Section+Line+Grid.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// A grid in the ``Song/Section/Line``
    struct Grid: Identifiable {
        /// The unique ID
        var id: Int
        /// The parts in the grid
        var parts = [Part]()
    }
}
