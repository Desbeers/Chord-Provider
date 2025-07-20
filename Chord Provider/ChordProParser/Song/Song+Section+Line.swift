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
        /// The source of the line
        var source: String = ""
        /// The parsed source
        var sourceParsed: String = ""
        /// The length of the line, the lyrics and loose chords
        var lineLength: String = ""

        /// The optional `Directive` of the section
        var directive: ChordPro.Directive?
        /// The optional arguments of the directive
        var arguments: ChordProParser.DirectiveArguments?
        /// The type of the line
        var type: ChordPro.LineType = .unknown
        /// The context of the line
        var context: ChordPro.Environment?

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

        mutating func calculateSource() {
            if let directive {
                if ChordPro.Directive.customDirectives.contains(directive) {
                    /// Just use the current source; its internal stuff and not a real directive
                    sourceParsed = source.trimmingCharacters(in: .whitespaces)
                } else if let arguments = ChordProParser.argumentsToString(self) {
                    sourceParsed = "{\(directive.rawValue.long) \(arguments)}"
                } else {
                    /// Only a directive
                    sourceParsed = "{\(directive.rawValue.long)}"
                }
            } else {
                sourceParsed = source.trimmingCharacters(in: .whitespaces)
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
        case sourceParsed
        case lineLength
        case warnings
        case parts
        case grid
        case strum
        case plain
        case type
        case context
    }
    /// :nodoc:
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

        /// Decode an optional directive string to a ``ChordPro/Directive``
        if let directive = try container.decodeIfPresent(String.self, forKey: .directive) {
            self.directive = ChordProParser.getDirective(directive)?.directive
        } else {
            self.directive = nil
        }

        /// Decode an optional context string to a ``ChordPro/Environment``
        if let context = try container.decodeIfPresent(String.self, forKey: .context) {
            self.context = ChordPro.Environment(rawValue: context)
        } else {
            self.context = nil
        }

        /// Decode a type string to a ``Song/Section/Line/LineType``
        let type = try container.decode(String.self, forKey: .type)
        self.type = ChordPro.LineType(rawValue: type) ?? .unknown

        /// Decode the arguments dictionary into `[String: String]`
        if let stringDictionary = try container.decodeIfPresent([String: String].self, forKey: .arguments) {
            var enumDictionary: [ChordPro.Directive.FormattingAttribute: String] = [:]
            for (stringKey, value) in stringDictionary {
                guard let key = ChordPro.Directive.FormattingAttribute(rawValue: stringKey) else {
                    return
                }
                enumDictionary[key] = value
            }
            self.arguments = enumDictionary
        } else {
            self.arguments = nil
        }

        self.sourceLineNumber = try container.decode(Int.self, forKey: .sourceLineNumber)
        self.source = try container.decode(String.self, forKey: .source)
        self.sourceParsed = try container.decode(String.self, forKey: .sourceParsed)
        self.lineLength = try container.decode(String.self, forKey: .lineLength)
        self.warnings = try container.decodeIfPresent(Set<String>.self, forKey: .warnings)
        self.parts = try container.decodeIfPresent([Song.Section.Line.Part].self, forKey: .parts)
        self.grid = try container.decodeIfPresent([Song.Section.Line.Grid].self, forKey: .grid)
        self.strum = try container.decodeIfPresent([[Strum]].self, forKey: .strum)
        self.plain = try container.decodeIfPresent(String.self, forKey: .plain)
    }
    /// :nodoc:
    func encode(to encoder: any Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.sourceLineNumber, forKey: .sourceLineNumber)

        /// Encode an optional directive ``ChordPro/Directive`` to a String
        try container.encodeIfPresent(self.directive?.rawValue.long, forKey: .directive)

        /// Encode a type ``ChordPro/LineType`` to a String
        try container.encode(self.type, forKey: .type)

        /// Encode arguments into a ``ChordProParser/DirectiveArguments`` dictionary
        var stringDictionary: [String: String]?
        if let arguments = self.arguments {
            stringDictionary = Dictionary(
                uniqueKeysWithValues: arguments.map { ($0.rawValue, $1) }
            )
        }
        try container.encodeIfPresent(stringDictionary, forKey: .arguments)

        /// Encode an optional context ``ChordPro/Environment`` to a String
        try container.encodeIfPresent(self.context?.rawValue, forKey: .context)

        try container.encode(self.source, forKey: .source)
        try container.encode(self.sourceParsed, forKey: .sourceParsed)
        try container.encode(self.lineLength, forKey: .lineLength)
        try container.encodeIfPresent(self.warnings, forKey: .warnings)
        try container.encodeIfPresent(self.parts, forKey: .parts)
        try container.encodeIfPresent(self.grid, forKey: .grid)
        try container.encodeIfPresent(self.strum, forKey: .strum)
        try container.encodeIfPresent(self.plain, forKey: .plain)
    }
}
