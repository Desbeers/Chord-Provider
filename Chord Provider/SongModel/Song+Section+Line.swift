//
//  Song+Section+Line.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension Song.Section {

    /// A line in the ``Song/Section``
    struct Line: Identifiable {
        /// The unique ID
        var id: Int
        /// The optional parts in the line
        var parts = [Part]()
        /// The  optional grid in the line
        var grid = [Grid]()
        /// The optional tab  in the line
        var tab: String = ""
        /// The optional comment in the line
        var comment: String = ""
        /// The optional strum pattern in the line
        var strum = [String]()
    }
}
