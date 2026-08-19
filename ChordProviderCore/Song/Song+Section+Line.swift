//
//  Song+Section+Line.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Song.Section {

    /// A line in the ``Song/Section``
    ///
    /// This is a line in the source document, parsed into components
    public struct Line: Identifiable, Equatable, Codable, Sendable {

        /// Init a line
        /// - Parameters:
        ///   - sourceLineNumber: The line number in the **ChordPro** document
        ///   - source: The source of the line
        ///   - sourceParsed: The parsed source
        ///   - lineLength: The length of the line, the lyrics and loose chords
        ///   - directive: The optional `Directive` of the section
        ///   - arguments: The optional arguments of the directive
        ///   - type: The type of the line
        ///   - context: The context of the line
        ///   - warnings: Optional warnings about the content of the line
        ///   - parts: The optional parts in the line
        ///   - gridsLine: The  optional grids in the line
        ///   - gridColumns: The  optional grid columns in the line
        ///   - tabLines: The  optional tab lines
        ///   - plain: A plain text version of the line
        public init(
            sourceLineNumber: Int = 0,
            source: String = "",
            sourceParsed: String = "",
            lineLength: String? = nil,
            directive: ChordPro.Directive? = nil,
            arguments: ChordProParser.DirectiveArguments? = nil,
            type: ChordPro.LineType = .unknown,
            context: ChordPro.Environment = .unknown,
            warnings: [LogUtils.LogMessage] = [],
            parts: [Song.Section.Line.Part] = [],
            gridsLine: [Song.Section.Line.Grid] = [],
            gridColumns: [Song.Section.Line.Grid] = [],
            tabLines: [Song.Section.Line.Tab] = [],
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
            self.tabLines = tabLines
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
        public var context: ChordPro.Environment = .unknown
        /// The optional parts in the line
        /// - Note: A part mostly consist of some text with a chord
        public var parts: [Part] = []
        /// The  optional grids in the line
        /// - Note: This will be processed by the parser at the end and added to *columns*
        public var gridsLine: [Grid]
        /// The  optional grid columns in the line
        public var gridColumns: [Grid]
        /// The  optional tab lines
        public var tabLines: [Tab]
        /// A plain text version of the line
        /// - Note: The lyrics of a line, a comment or a tab for example
        public var plain: String?
        /// Optional warnings about the content of the line
        public var warnings: [LogUtils.LogMessage]

        // MARK: Calculated values

        /// The calculated label of the directive
        public var label: String {
            arguments?[.plain] ?? arguments?[.label] ?? plain ?? context.label
        }

        /// The whole line with prefix and suffix split by a lenght based on a lyric
        /// - Parameter length: The maximum lengt of a String
        /// - Returns: An Array of Strings
        public func wholeText(split length: Int) -> [String] {
            var result: [String] = []
            var currentLine = ""
            var currentLength = 0
            for part in parts {
                switch part.content {
                case .lyric(let lyric):
                    switch lyric.chordSlot {
                    case let .chord(definition, textPart):
                        appendPart(
                            plain: "'\(definition.display)' ",
                            output: "'<b>\(stripSpaces(textPart.display))</b>' "
                        )
                    case let .text(textPart):
                        appendPart(
                            plain: "'\(textPart.text)' ",
                            output: "'<b>\(stripSpaces(textPart.display))</b>' "
                        )
                    case .empty:
                        break
                    }
                    for textPart in lyric.textParts {
                        if textPart.suffix.isEmpty {
                            /// Just plain text, add word by word
                            /// - Note: This is to split a long line as well
                            let splitParts = textPart.text.split(separator: " ")
                            for splitPart in splitParts {
                                let string = "\(String(splitPart)) "
                                appendPart(plain: string, output: string)
                            }
                        } else {
                            /// Don't break the textPart
                            appendPart(plain: textPart.text, output: "\(textPart.display) ")
                        }
                    }
                default:
                    /// We only deal with lyrics
                    continue
                }
            }
            /// Add the remaining part
            /// - Note: The last space will be removed here
            result.append(currentLine.trimmingCharacters(in: .whitespaces))
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
            /// Strip spaces fron chords
            /// - Chords have a space added at the end to avoid sticking,
            ///   but we show them *inline* now
            func stripSpaces(_ text: String) -> String {
                text.trimmingCharacters(in: .whitespaces)
            }
        }

        /// Bool if the line has lyrics
        public var hasLyrics: Bool {
            let result = parts.compactMap(\.content.lyricHasText)
            return result.contains(true)
        }

        /// Bool if the line has chords
        public var hasChords: Bool {
            let result = parts.compactMap(\.content.lyricHasChord)
            return result.contains(true)
        }

        // MARK: Mutating functions

        /// Add a single warning to the set of warnings
        /// - Parameters:
        ///   - warning: The warning as ``LogUtils/LogMessage``
        ///   - level: The level of the warning
        mutating func addWarning(_ warning: LogUtils.LogMessage, level: LogUtils.Level) {
            self.warnings.append(warning)
            let line = sourceLineNumber
            LogUtils.shared.setLog(
                level: level,
                category: .songParser,
                lineNumber: line,
                source: source,
                message: "\(warning.message)"
            )
        }

        /// Add a single warning to the set of warnings
        /// - Parameters:
        ///   - warning: The warning a `String`
        ///   - level: The level of the warning
        /// - Note: warnings are *optionals* so we can not just 'insert' it
        mutating func addWarning(_ warning: String, level: LogUtils.Level) {
            let lineWarning = LogUtils.LogMessage(level: level, category: .songParser, message: warning)
            addWarning(lineWarning, level: level)
        }

        /// Calculate the source of the line
        mutating func calculateSource() {
            if let directive {
                let colon = plain == nil ? "" : ":"
                if ChordPro.Directive.customDirectives.contains(directive) {
                    /// Just use the current source; its internal stuff and not a real directive
                    sourceParsed = source.trimmingCharacters(in: .whitespaces)
                } else if let stringArguments = ChordProParser.argumentsToString(self) {
                    sourceParsed = "{\(directive.source.long)\(colon) \(stringArguments)}"
                } else {
                    /// Only a directive
                    sourceParsed = "{\(directive.source.long)}"
                }
            } else {
                sourceParsed = source.trimmingCharacters(in: .whitespaces)
            }
        }
    }
}
