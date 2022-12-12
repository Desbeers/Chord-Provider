//
//  Song+Section.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Song {

    // MARK: The structure of a section in the song

    /// A section in the ``Song``
    struct Section: Identifiable {
        /// The unique ID
        var id: Int
        /// The optional label of the section
        var label: String?
        /// The `Environment type` of the section
        var type: ChordPro.Environment = .none
        /// Bool if the Environment is automatic set or not
        var autoType: Bool = false
        /// The lines in the section
        var lines = [Line]()
    }
}
