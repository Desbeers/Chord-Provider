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
        var label: String {
            arguments?[.label] ?? arguments?[.plain] ?? ""
        }
        /// The `Environment type` of the section
        var environment: ChordPro.Environment = .none
        /// The optional ``ChordPro/Directive`` as string when the section contains only one line
        ///
        /// Examples:
        /// ```swift
        /// {title}
        /// {define}
        /// ```
        /// The lines in the section
        var lines: [Line] = []
        /// Boolean if the section is automatic created
        ///
        /// This happens mostly for lines with text and chords that are not surrounded by a `{start_of_verse}` and `{end_of_verse}`
        ///
        /// But also for a `Tab` or `Grid` when a line starts with an '|'
        ///
        /// The editor will show a warning when the section is automatically created with an assumed ``ChordPro/Environment``.
        ///
        /// - Note: Automatically created sections will end with an 'newline', unlike defined sections.
        var autoCreated: Bool
        /// The optional arguments of the section; taken from the first line of the section
        var arguments: ChordProParser.DirectiveArguments? {
            if let firstLine = lines.first {
                return firstLine.arguments
            }
            return nil
        }
        /// Optional warnings for this section
        private(set) var warnings: Set<String>?
        /// - Note: warnings are *optionals* so we can not just 'insert' it
        mutating func addWarning(_ warning: String) {
            if self.warnings == nil {
                self.warnings = [warning]
            } else {
                self.warnings?.insert(warning)
            }
        }
        /// Reset all the warnings
        mutating func resetWarnings() {
            self.warnings = nil
        }
    }
}
