//
//  Song+Section+Line.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section {

    /// A line in the ``Song/Section``
    ///
    /// This is a line in the source document, parsed into components
    public struct Line: Identifiable, Equatable, Codable, Sendable {
        public init(
            sourceLineNumber: Int = 0,
            source: String = "",
            sourceParsed: String = "",
            lineLength: String? = nil,
            directive: ChordPro.Directive? = nil,
            arguments: ChordProParser.DirectiveArguments? = nil,
            type: ChordPro.LineType = .unknown,
            context: ChordPro.Environment = .none,
            warnings: [LogUtils.LogMessage]? = nil,
            parts: [Song.Section.Line.Part]? = nil,
            grid: [Song.Section.Line.Grid]? = nil,
            strumGroup: [Song.Section.Line.StrumGroup]? = nil,
            plain: String? = nil
        ) {
            self.sourceLineNumber = sourceLineNumber
            self.source = source
            self.sourceParsed = sourceParsed
            self.lineLength = lineLength
            self.directive = directive
            self.arguments = arguments
            self.type = type
            self.context = context
            self.warnings = warnings
            self.parts = parts
            self.grid = grid
            self.strumGroup = strumGroup
            self.plain = plain
        }

        /// The unique ID of the line
        /// - Note: This is the line number in the source
        public var id: Int {
            sourceLineNumber
        }
        /// The line number in the **ChordPro** document
        public var sourceLineNumber: Int = 0
        /// The source of the line
        public var source: String = ""
        /// The parsed source
        public var sourceParsed: String = ""
        /// The length of the line, the lyrics and loose chords
        /// - Note: Used for rendering
        public var lineLength: String?

        /// The optional `Directive` of the section
        public var directive: ChordPro.Directive?
        /// The optional arguments of the directive
        public var arguments: ChordProParser.DirectiveArguments?
        /// The type of the line
        public var type: ChordPro.LineType = .unknown
        /// The context of the line
        public var context: ChordPro.Environment = .none

        /// The optional parts in the line
        ///
        /// A part mostly consist of some text with a chord
        public var parts: [Part]?
        /// The  optional grid in the line
        private(set) public var grid: [Grid]?
        /// The  optional grid columns in the line
        /// - Note: there is a function to move grids into columns for rendering
        public var gridColumns: GridColumns?

        /// The optional strum pattern in the line
        public var strumGroup: [StrumGroup]?

        /// A plain text version of the line
        /// - Note: The lyrics of a line, a comment or a tab for example
        public var plain: String?

        /// The calculated label of the directive
        public var label: String {
            arguments?[.plain] ?? arguments?[.label] ?? plain ?? context.label
        }

        /// Optional warnings about the content of the line
        private(set) public var warnings: [LogUtils.LogMessage]?

        /// Add a single warning to the set of warnings
        /// - Note: warnings are *optionals* so we can not just 'insert' it
        mutating func addWarning(_ warning: LogUtils.LogMessage, level: LogUtils.Level = .warning) {

            //let warning = LogUtils.LogMessage(level: level, category: .songParser, message: warning)

            if self.warnings == nil {
                self.warnings = [warning]
            } else {
                self.warnings?.append(warning)
            }
            let line = sourceLineNumber
            LogUtils.shared.setLog(
                level: level,
                category: .songParser,
                lineNumber: line,
                message: "\(warning.message)"
            )
        }

        /// Add a single warning to the set of warnings
        /// - Note: warnings are *optionals* so we can not just 'insert' it
        mutating func addWarning(_ warning: String, level: LogUtils.Level = .warning) {

            let warning = LogUtils.LogMessage(level: level, category: .songParser, message: warning)

            if self.warnings == nil {
                self.warnings = [warning]
            } else {
                self.warnings?.append(warning)
            }
            let line = sourceLineNumber
            LogUtils.shared.setLog(
                level: level,
                category: .songParser,
                lineNumber: line,
                message: "\(warning.message)"
            )
        }

        /// Add a set of warnings
        mutating func addWarning(_ warning: [LogUtils.LogMessage]) {
            let warningLine = warning.map(\.message).joined(separator: "\n")
            let line = sourceLineNumber
            LogUtils.shared.setLog(
                level: .warning,
                category: .songParser,
                lineNumber: line,
                message: warningLine
            )
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
        case strumGroup
        case plain
        case type
        case context
    }
    /// :nodoc:
    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

        /// Decode an optional directive string to a ``ChordPro/Directive``
        if let directive = try container.decodeIfPresent(String.self, forKey: .directive) {
            self.directive = ChordProParser.getDirective(directive)?.directive
        } else {
            self.directive = nil
        }

        /// Decode the context string to a ``ChordPro/Environment``
        let context = try container.decode(String.self, forKey: .context)
        self.context = ChordPro.Environment(rawValue: context) ?? .none

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
        self.lineLength = try container.decodeIfPresent(String.self, forKey: .lineLength)
        self.warnings = try container.decodeIfPresent([LogUtils.LogMessage].self, forKey: .warnings)
        self.parts = try container.decodeIfPresent([Song.Section.Line.Part].self, forKey: .parts)
        self.grid = try container.decodeIfPresent([Song.Section.Line.Grid].self, forKey: .grid)
        self.strumGroup = try container.decodeIfPresent([StrumGroup].self, forKey: .strumGroup)
        self.plain = try container.decodeIfPresent(String.self, forKey: .plain)
    }
    /// :nodoc:
    public func encode(to encoder: any Encoder) throws {
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
        try container.encode(self.context.rawValue, forKey: .context)

        try container.encode(self.source, forKey: .source)
        try container.encode(self.sourceParsed, forKey: .sourceParsed)
        try container.encodeIfPresent(self.lineLength, forKey: .lineLength)
        try container.encodeIfPresent(self.warnings, forKey: .warnings)
        try container.encodeIfPresent(self.parts, forKey: .parts)
        try container.encodeIfPresent(self.grid, forKey: .grid)
        try container.encodeIfPresent(self.strumGroup, forKey: .strumGroup)
        try container.encodeIfPresent(self.plain, forKey: .plain)
    }
}
