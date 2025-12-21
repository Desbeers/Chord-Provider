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
            strums: [Song.Section.Line.Strums]? = nil,
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
            self.strums = strums
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
        /// - Note: A part mostly consist of some text with a chord
        public var parts: [Part]?
        /// The  optional grid in the line
        public var grid: [Grid]?
        /// The  optional grid columns in the line
        /// - Note: there is a function to move grids into columns for rendering
        public var gridColumns: GridColumns?
        /// The optional strum pattern in the line
        public var strums: [Strums]?
        /// A plain text version of the line
        /// - Note: The lyrics of a line, a comment or a tab for example
        public var plain: String?
        /// Optional warnings about the content of the line
        public var warnings: [LogUtils.LogMessage]?

        // MARK: Calculated values

        /// The calculated label of the directive
        public var label: String {
            arguments?[.plain] ?? arguments?[.label] ?? plain ?? context.label
        }

        // MARK: Mutating functions

        /// Add a single warning to the set of warnings
        /// - Parameters:
        ///   - warning: The warning as ``LogUtils/LogMessage``
        ///   - level: The level of the warning
        /// - Note: warnings are *optionals* so we can not just 'insert' it
        mutating func addWarning(_ warning: LogUtils.LogMessage, level: LogUtils.Level = .warning) {
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
        /// - Parameters:
        ///   - warning: The warning a `String`
        ///   - level: The level of the warning
        /// - Note: warnings are *optionals* so we can not just 'insert' it
        mutating func addWarning(_ warning: String, level: LogUtils.Level = .warning) {
            let warning = LogUtils.LogMessage(level: level, category: .songParser, message: warning)
            addWarning(warning, level: level)
        }
        
        /// Calculate the source of the line
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


