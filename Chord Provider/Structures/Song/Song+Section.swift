//
//  Song+Section.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song {

    // MARK: The structure for a section in the `Song`

    /// A section in the ``Song``
    struct Section: Identifiable, Equatable, Codable {
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
        private(set) var warning: Set<String>?
        /// The optional arguments of the section
        var arguments: ChordProParser.Arguments?

        /// - Note: warnings are *optionals* so we can not just 'insert' it
        mutating func addWarning(_ warning: String) {
            if self.warning == nil {
                self.warning = [warning]
            } else {
                self.warning?.insert(warning)
            }
        }
        mutating func resetWarnings() {
            self.warning = nil
        }
    }
}
