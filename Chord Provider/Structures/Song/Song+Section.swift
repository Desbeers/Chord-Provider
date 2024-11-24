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
    struct Section: Identifiable, Codable {
        /// The unique ID of the section
        var id: Int
        /// The label of the section
        var label: String = ""
        /// The `Environment type` of the section
        var environment: ChordPro.Environment = .none
        /// The lines in the section
        var lines: [Line] = []
        /// Boolean if the section is automatic created
        ///
        /// This happens mostly for lines with test and chords that is not surrounded by a `{start_of_verse}` and `{end_of_verse}`
        ///
        /// But also for a `Tab` or `Grid` when a line starts with an '|'
        ///
        /// The editor will show a warning when the section is automatically created with an assumed ``ChordPro/Environment``.
        ///
        /// - Note: Automatically created sections will end with an 'newline', unlike defined sections.
        var autoCreated: Bool
        /// Optional warning for this section
        var warning: String?
    }
}
