//
//  Song+Section+Line.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Song.Section {

    /// A line in the ``Song/Section``
    ///
    /// This is a line in the source document, parsed into components
    struct Line: Identifiable, Equatable, Codable {
        /// The unique ID of the line
        /// - Note: This is the line number in the source
        var id: Int {
            sourceLineNumber
        }
        /// The line number in the **ChordPro** document
        var sourceLineNumber: Int = 0


        /// The `Environment` of the line
        var environment: ChordPro.Environment = .none

        /// The `Directive` of the section
        var directive: ChordPro.Directive = .none

        /// The optional argument of the directive
        var argument: String = ""

        /// The source of the line
        var source: String = ""

        /// Optional warnings about the content of the line
        private(set) var warning: Set<String>?


        /// The optional parts in the line
        ///
        /// A part mostly consist of some text with a chord
        var parts: [Part]?
        /// The  optional grid in the line
        private(set) var grid: [Grid]?
        /// The optional strum pattern in the line
        var strum: [String]?


        /// - Note: warnings are *optionals* so we can not just 'insert' it
        mutating func addWarning(_ warning: String) {
            if self.warning == nil {
                self.warning = [warning]
            } else {
                self.warning?.insert(warning)
            }
        }

        /// - Note: grids are *optionals* so we can not just 'insert' it
        mutating func addGrid(_ grid: Grid) {
            if self.grid == nil {
                self.grid = [grid]
            } else {
                self.grid?.append(grid)
            }
        }
    }
}
