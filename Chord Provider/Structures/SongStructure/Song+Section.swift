//
//  Song+Section.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Song {

    // MARK: The structure for a section in the `Song`

    /// A section in the ``Song``
    struct Section: Identifiable {
        /// The unique ID
        var id: Int
        /// The optional label of the section
        var label: String = ""
        /// The `Environment type` of the section
        var type: ChordPro.Environment = .none
        /// The lines in the section
        var lines = [Line]()
        /// Bool if the section is automatic created
        var autoCreated: Bool
    }
}
