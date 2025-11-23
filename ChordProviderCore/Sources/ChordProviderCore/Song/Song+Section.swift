//
//  Song+Section.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song {

    // MARK: The structure for a section in the `Song`

    /// A section in the ``Song``
    public struct Section: Identifiable, Equatable, Codable, Sendable {
        /// The unique ID of the section
        public var id: Int
        /// The label of the section
        public var label: String {
            arguments?[.label] ?? arguments?[.plain] ?? environment.label
        }
        /// The `Environment type` of the section
        public var environment: ChordPro.Environment = .none
        /// The optional ``ChordPro/Directive`` as string when the section contains only one line
        ///
        /// Examples:
        /// ```swift
        /// {title}
        /// {define}
        /// ```
        /// The lines in the section
        public var lines: [Line] = []
        /// Boolean if the section is automatic created
        ///
        /// This happens mostly for lines with text and chords that are not surrounded by a `{start_of_verse}` and `{end_of_verse}`
        ///
        /// But also for a `Tab` or `Grid` when a line starts with an '|'
        ///
        /// The editor will show a warning when the section is automatically created with an assumed ``ChordPro/Environment``.
        ///
        /// - Note: Automatically created sections will end with an 'newline', unlike defined sections.
        public var autoCreated: Bool?
        /// The optional arguments of the section; taken from the first line of the section
        public var arguments: ChordProParser.DirectiveArguments? {
            if let firstLine = lines.first {
                return firstLine.arguments
            }
            return nil
        }
        /// Optional warnings for this section
        private(set) public var warnings: [LogUtils.LogMessage]?
        /// - Note: warnings are *optionals* so we can not just 'insert' it
        mutating func addWarning(_ warning: String, level: LogUtils.Level = .warning) {

            let warning = LogUtils.LogMessage(level: level, category: .songParser, message: warning)

            if self.warnings == nil {
                self.warnings = [warning]
            } else {
                self.warnings?.append(warning)
            }
        }
        /// Reset all the warnings
        mutating func resetWarnings() {
            self.warnings = nil
        }
        /// Convert grids into columns
        /// - Returns: A new ``Song/Section``
        public func gridColumns() -> Song.Section {
            var newSection = self
            newSection.lines = []
            /// Give all parts an unique id
            var partID: Int = 1
            /// Get the maximum columns
            let maxColumns = self.lines.compactMap { $0.grid }.reduce(0) { accumulator, grids in
                let elements = grids.flatMap { $0.cells }.count
                return max(accumulator, elements)
            }
            var elements: [Song.Section.Line.Grid] = (0 ..< maxColumns).enumerated().map { item in
                Song.Section.Line.Grid(id: item.element)
            }
            for line in self.lines {
                if let grid = line.grid {
                    let parts = grid.flatMap { $0.cells }
                    for (column, part) in parts.enumerated() {
                        var part = part
                        part.id = partID
                        elements[column].cells.append(part)
                        partID += 1
                    }
                    /// Fill the grid if needed
                    if parts.count < maxColumns {

                        for column in (parts.count..<maxColumns) {
                            let cell = Song.Section.Line.GridCell(id: partID, parts: [Song.Section.Line.Part(id: partID, text: "")])

                            elements[column].cells.append(cell)
                            partID += 1
                        }
                    }
                } else {
                    if  let first = elements.first, !first.cells.isEmpty {
                        /// Add this as item
                        var newLine: Song.Section.Line = .init(type: .songLine)
                        newLine.gridColumns = Song.Section.Line.GridColumns(id: line.sourceLineNumber, grids: elements)
                        newSection.lines.append(newLine)
                        /// Clear the grid
                        elements = (0 ..< maxColumns).enumerated().map { item in
                            Song.Section.Line.Grid(id: item.element)
                        }
                    }
                    /// Add the other line
                    newSection.lines.append(line)
                }
            }
            return newSection
        }
    }
}
