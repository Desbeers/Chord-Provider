//
//  ChordProParser+processGrid.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a grid environment

    /// Process a grid environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processGrid(
        text: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        /// Try to get the shape
        var shape = Song.Section.Line.Grid.Shape()
        if let argument = currentSection.lines.first?.arguments?[.shape],
            let match = argument.wholeMatch(of: RegexDefinitions.shape)
        {
            if let left = match.1, let value = Int(left) {
                shape.left = value
            }
            shape.measures = Int(match.2) ?? shape.measures
            shape.beats = Int(match.3) ?? shape.beats
            if let right = match.4, let value = Int(right) {
                shape.right = value
            }
        }

        /// Start with a fresh line:
        var line = Song.Section.Line(
            sourceLineNumber: song.totalLines,
            source: text,
            sourceParsed: text,
            type: .songLine,
            context: .grid
        )
        /// The ID of the cell
        var cellID: Int = 0
        /// The ID of the part
        var partID: Int = 0
        /// The optional active strum pattern for this line
        var activeStrumPattern: ChordPro.Grid.StrumPattern?
        /// The separated grid parts in a String Array
        var grids = splitRespectingMarkup(text)
        /// Check if there are margins at the beginning and add spaces if needed
        if text.starts(with: " "), shape.left > 0 {
            for _ in 0..<shape.left {
                /// Insert a spacer
                grids.insert(" ", at: 0)
            }
        }
        /// Check if there are margins at the end and add spaces if needed
        if let last = text.last, shape.right > 0, String(last) == " " {
            for _ in 0..<shape.right {
                /// Append a spacer
                grids.append(" ")
            }
        }
        for (cellIndex, gridText) in grids.enumerated() {
            guard !gridText.isEmpty else { continue }
            var grid = Song.Section.Line.Grid(id: cellID)
            /// Multiple items can be put in a single cell by separating the chord names with a ~ (tilde)
            let items = gridText.split(separator: "~")
            /// Collect the parts
            var parts: [Song.Section.Line.Part] = []
            for item in items {
                let textPart = String(item).textPart(handleBrackets: true)
                let text = textPart.text
                /// Convert text into a grid token
                let gridToken = parseGridTextToToken(
                    text: text,
                    cellIndex: cellIndex,
                    shape: shape,
                    textPart: textPart,
                    activeStrumPattern: activeStrumPattern
                )
                /// Create a new part
                var part = Song.Section.Line.Part(id: partID)
                /// Fill the part
                switch gridToken {
                /// Text in the margin
                case let .margin(textPart):
                    part.content = .margin(textPart: textPart)
                /// Just plain text
                case let .text(textPart):
                    part.content = .text(textPart: textPart)
                /// Strum pattern symbol
                case let .strumPattern(pattern):
                    activeStrumPattern = pattern
                    part.content = .strumPattern(symbol: pattern)
                /// Bar line symbol
                case let .barLine(symbol):
                    if let activeStrumPattern {
                        part.content = .strumPattern(symbol: activeStrumPattern)
                    } else {
                        part.content = .barLine(symbol: symbol)
                    }
                /// Strum symbol
                case let .strum(strum):
                    part.content = .strum(symbol: strum)
                /// Repeating symbol
                case let .repeating(symbol):
                    part.content = .repeating(symbol: symbol)
                /// A specific Chord
                case let .chord(textPart):
                    let definition = processChord(
                        chord: text,
                        line: &line,
                        song: &song
                    )
                    var textPart = textPart
                    textPart.text = definition.display
                    part.content = .chord(definition: definition, textPart: textPart, beatItems: 1)
                    currentSection.haveChords = true
                /// Any chord
                case let .anyChord(textPart, strum):
                    var chord = ChordDefinition(
                        text: text,
                        kind: .anyChord
                    )
                    part.content = .anyChord(textPart: textPart, beatItems: 1, strum: strum)
                    chord.strum = .noStrum
                /// Text that should be rendered in a chord slot
                case let .textChord(textPart):
                    part.content = .textChord(textPart: textPart)
                }
                parts.append(part)
                partID += 1
            }
            grid.cells.append(Song.Section.Line.GridCell(id: cellID, parts: parts))
            cellID += 1
            line.addGrid(grid)
        }
        /// Set the context
        line.context = currentSection.environment
        /// Add the line"
        currentSection.lines.append(line)
        /// Mark the section as Grid if not set
        if currentSection.environment == .unknown {
            autoSection(
                environment: .grid,
                currentSection: &currentSection
            )
        }
    }
}

extension ChordProParser {

    /// The token in the grid
    private enum GridToken {
        /// Text in the margin
        case margin(textPart: Song.TextPart)
        /// Just plain text
        case text(textPart: Song.TextPart)
        /// Strum pattern symbol
        case strumPattern(ChordPro.Grid.StrumPattern)
        /// Bar line symbol
        case barLine(ChordPro.Grid.BarLineSymbol)
        /// Strum symbol
        case strum(Chord.Strum)
        /// Repeating symbol
        case repeating(ChordPro.Grid.RepeatingSymbol)
        /// A specific chord
        case chord(textPart: Song.TextPart)
        /// Any chord
        case anyChord(textPart: Song.TextPart, strum: Chord.Strum)
        /// Text Chord
        /// - Note: Just text that should be rendered in a chord slot
        case textChord(textPart: Song.TextPart)
    }
}

extension ChordProParser {

    /// Parse the grid text into a grid token
    /// - Parameters:
    ///   - text: The text
    ///   - cellIndex: The cell index of the text
    ///   - shape: The optional shape argument of the grid directive
    ///   - textPart: The text with optional prefix and suffix
    ///   - activeStrumPattern: The optional active strum pattern of the line
    ///
    /// - Returns: A grid token with its values
    private static func parseGridTextToToken(
        text: String,
        cellIndex: Int,
        shape: Song.Section.Line.Grid.Shape,
        textPart: Song.TextPart,
        activeStrumPattern: ChordPro.Grid.StrumPattern?
    ) -> GridToken {
        /// Check if it is a spacer or if it is text within the margins
        /// - Note: Margins are determined by shape offsets and leading whitespace
        let isWhitespace = text.starts(with: " ")
        let isLeftMargin = cellIndex < shape.left
        let isRightMargin = cellIndex >= shape.totalCells - shape.right
        if isWhitespace || isLeftMargin || isRightMargin {
            return .margin(textPart: textPart)
        }
        /// Just plain text
        /// - Note: The '*' will be removed
        if text.starts(with: "*") {
            let stripped = String(text.dropFirst())
            var updatedMarkup = textPart
            updatedMarkup.text = stripped
            return .text(textPart: updatedMarkup)
        }
        /// Strum pattern symbol
        if let pattern = ChordPro.Grid.StrumPattern.characterDictionary[text] {
            return .strumPattern(pattern)
        }
        /// Bar line symbol
        if let bar = ChordPro.Grid.BarLineSymbol.characterDictionary[text] {
            return .barLine(bar)
        }
        /// Strum symbol
        /// - Note: This will be added like that only when the line has an active strum pattern defined
        if activeStrumPattern != nil,
            let strum = Chord.Strum.characterDictionary[text]
        {
            return .strum(strum)
        }
        /// Repeating symbol
        if let repeating = ChordPro.Grid.RepeatingSymbol.characterDictionary[text] {
            return .repeating(repeating)
        }
        /// We've been to all the special items in a grid, so eventualy, this must be a chord
        switch text {
        case ".":
            /// Don't play this chord
            return .anyChord(textPart: textPart, strum: .noStrum)
        case "/":
            /// Any Chord
            return .anyChord(textPart: textPart, strum: .down)
        default:
            /// This should be a specific chord that will be parsed later
            return .chord(textPart: textPart)
        }
    }
}

extension ChordProParser {

    /// Split a string by space or markup block
    /// - Parameter text: The text to split
    /// - Returns: The array with String elements
    static private func splitRespectingMarkup(_ text: String) -> [String] {
        var result: [String] = []
        var current = ""
        var insideTag = false
        for character in text {
            switch character {
            case "<":
                insideTag = true
                current.append(character)
            case ">":
                insideTag = false
                current.append(character)
            case " ":
                if insideTag {
                    current.append(character)
                } else {
                    if !current.isEmpty {
                        result.append(current)
                        current = ""
                    }
                }
            default:
                current.append(character)
            }
        }
        /// Append the remaining, if any
        if !current.isEmpty {
            result.append(current)
        }
        /// Return the result
        return result
    }
}
