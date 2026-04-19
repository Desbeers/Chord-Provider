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
            gridsLine: [Song.Section.Line.Grid]? = nil,
            gridColumns: [Song.Section.Line.GridCell]? = nil,
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
            self.gridsLine = gridsLine
            self.gridColumns = gridColumns
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
        /// The  optional grids in the line
        /// - Note: This will be removed by the parser at the end and moved to *grid* in *columns*
        public var gridsLine: [Grid]?
        /// The  optional grid columns in the line
        public var gridColumns: [GridCell]?
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
        
        /// The whole line with markup split by a lenght
        /// - Parameter length: The maximum lengt of a String
        /// - Returns: An Array of Strings
        public func wholeTextWithMarkup(split length: Int) -> [String] {
            var result: [String] = []
            var currentLine = ""
            var currentLength = 0
            guard let parts else { return [] }
            for part in parts {
                if let chord = part.chordDefinition, var output = part.chordMarkup {
                    /// Give it some extra styling
                    output.open += "<b><i>"
                    output.close = "</i></b>" + output.close + " "
                    appendPart(plain: chord.name, output: "\(output.open)\(output.text)\(output.close)")
                }
                if let textParts = part.textMarkup {
                    for part in textParts {
                        if part.close.isEmpty {
                            /// Just plain text, add word by word
                            /// - Note: This is to split a long line as well
                            let parts = part.text.split(separator: " ")
                            for part in parts {
                                let string = "\(String(part)) "
                                appendPart(plain: string, output: string)
                            }
                        } else {
                            /// Don't break the markup
                            appendPart(plain: part.text, output: "\(part.open)\(part.text)\(part.close) ")
                        }
                    }
                }
            }
            /// Add the remaining part
            /// - Note: The last space will be removed here
            result.append(currentLine.trimmingCharacters(in: .whitespaces))
            /// Return the result
            return result

            /// Helper to add a part
            /// - Parameters:
            ///   - plain: The plain text
            ///   - output: The text to output
            func appendPart(plain: String, output: String) {
                if currentLength + plain.count >= length {
                    /// Reached the maximum lenght, add it to the result
                    result.append(currentLine)
                    currentLine = ""
                    currentLength = 0
                }
                currentLine += output
                currentLength += plain.count
            }
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
                let colon = plain == nil ? "" : ":"
                if ChordPro.Directive.customDirectives.contains(directive) {
                    /// Just use the current source; its internal stuff and not a real directive
                    sourceParsed = source.trimmingCharacters(in: .whitespaces)
                } else if let arguments = ChordProParser.argumentsToString(self) {
                    sourceParsed = "{\(directive.rawValue.long)\(colon) \(arguments)}"
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
