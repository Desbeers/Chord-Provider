//
//  Song+Section+Line.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

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

        /// The `Directive` of the section
        var directive: ChordPro.Directive = .unknown

        /// The optional arguments of the directive
        var arguments: ChordProParser.DirectiveArguments?

        /// The source of the line
        var source: String = ""

        /// Optional warnings about the content of the line
        private(set) var warnings: Set<String>?

        /// The optional parts in the line
        ///
        /// A part mostly consist of some text with a chord
        var parts: [Part]?
        /// The  optional grid in the line
        private(set) var grid: [Grid]?
        /// The optional strum pattern in the line
        var strum: [[Strum]]?

        /// The calculated label of the directive
        var label: String {
            arguments?[.plain] ?? arguments?[.label] ?? ""
        }

        /// A plain text version of the line
        /// - Note: The lyrics of a line, a comment or a tab for example
        var plain: String?

        /// Add a single warning to the set of warnings
        /// - Note: warnings are *optionals* so we can not just 'insert' it
        mutating func addWarning(_ warning: String) {
            if self.warnings == nil {
                self.warnings = [warning]
            } else {
                self.warnings?.insert(warning)
            }
            let line = sourceLineNumber
            Logger.parser.fault("**Line \(line, privacy: .public)**\n\(warning, privacy: .public)")
        }

        /// Add a set of warnings
        mutating func addWarning(_ warning: Set<String>) {
            let warningLine = (["**Line \(sourceLineNumber)**"] + warning.map(\.description)).joined(separator: "\n")
            Logger.parser.fault("\(warningLine, privacy: .public)")
            self.warnings = warning
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

extension Song.Section.Line {
    /// :nodoc:
    enum CodingKeys: CodingKey {
        case sourceLineNumber
        case directive
        case arguments
        case source
        case warnings
        case parts
        case grid
        case strum
        case plain
    }
    /// :nodoc:
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

        self.sourceLineNumber = try container.decode(Int.self, forKey: .sourceLineNumber)
        let directive = try container.decode(String.self, forKey: .directive)
        self.directive = ChordProParser.getDirective(directive)?.directive ?? .unknown
        self.arguments = try container.decodeIfPresent(ChordProParser.DirectiveArguments.self, forKey: .arguments)
        self.source = try container.decode(String.self, forKey: .source)
        self.warnings = try container.decodeIfPresent(Set<String>.self, forKey: .warnings)
        self.parts = try container.decodeIfPresent([Song.Section.Line.Part].self, forKey: .parts)
        self.grid = try container.decodeIfPresent([Song.Section.Line.Grid].self, forKey: .grid)
        self.strum = try container.decodeIfPresent([[Strum]].self, forKey: .strum)
        self.plain = try container.decode(String.self, forKey: .plain)
    }
    /// :nodoc:
    func encode(to encoder: any Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.sourceLineNumber, forKey: .sourceLineNumber)
        try container.encode(self.directive.rawValue.long, forKey: .directive)
        try container.encodeIfPresent(self.arguments, forKey: .arguments)
        try container.encode(self.source, forKey: .source)
        try container.encodeIfPresent(self.warnings, forKey: .warnings)
        try container.encodeIfPresent(self.parts, forKey: .parts)
        try container.encodeIfPresent(self.grid, forKey: .grid)
        try container.encodeIfPresent(self.strum, forKey: .strum)
        try container.encode(self.plain, forKey: .plain)
    }
}
