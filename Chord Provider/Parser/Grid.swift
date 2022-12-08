//
//  Grid.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// A grid in the ``Song``
    struct Grid: Identifiable {
        var id: Int
        var parts = [Part]()
    }
}
