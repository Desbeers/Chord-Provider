//
//  ChordProParser+processGrid.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
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
        if let argument = currentSection.lines.first?.arguments?[.shape], let match = argument.wholeMatch(of: RegexDefinitions.shape) {
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
        var grids = text.matches(of: RegexDefinitions.gridSeparator).map { match in
            String(match.0)
        }
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
                let markup = String(item).markup(handleBrackets: true)
                let text = markup.text
                /// Convert text into a grid token
                let gridToken = parseGridTextToToken(
                    text: text,
                    cellIndex: cellIndex,
                    shape: shape,
                    markup: markup,
                    activeStrumPattern: activeStrumPattern
                )
                /// Create a new part
                var part = Song.Section.Line.Part(id: partID)
                /// Fill the part
                switch gridToken {
                /// Text in the margin
                case let .margin(text, markup):
                    part.text = text
                    part.strum = .init(isInMargin: true)
                    if let markup {
                        part.textMarkup = [markup]
                    }
                /// Just plain text
                case let .text(text, markup):
                    part.text = text
                    if let markup {
                        part.textMarkup = [markup]
                    }
                /// Strum pattern symbol
                case let .strumPattern(pattern):
                    activeStrumPattern = pattern
                    part.strum = .init(strumPattern: pattern)
                /// Bar line symbol
                case let .barLine(symbol):
                    if let activeStrumPattern {
                        part.strum = .init(strumPattern: activeStrumPattern)
                    } else {
                        part.strum = .init(barLineSymbol: symbol)
                    }
                /// Strum symbol
                case let .strum(strum):
                    part.strum = .init(strum: strum)
                /// Repeating symbol
                case let .repeating(symbol):
                    part.strum = .init(repeatingSymbol: symbol)
                /// Chord
                case let .chord(text, markup, isSpecial):
                    /// isSpecial is for "." (don't play) and "/" (play any)
                    if isSpecial {
                        var chord = ChordDefinition(
                            text: text == "/" ? "/" : "",
                            kind: text == "/" ? .anyChord : .textChord
                        )
                        chord.strum = .noStrum
                        part.chordDefinition = chord
                    } else {
                        let chord = processChord(
                            chord: text,
                            line: &line,
                            song: &song
                        )
                        part.chordDefinition = chord
                    }
                    part.chordMarkup = markup
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
        if currentSection.environment == .none {
            autoSection(
                environment: .grid,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}

extension ChordProParser {

    /// The token in the grid
    private enum GridToken {
        /// Text in the margin
        case margin(text: String, markup: Song.Markup?)
        /// Just plain text
        case text(text: String, markup: Song.Markup?)
        /// Strum pattern symbol
        case strumPattern(ChordPro.Grid.StrumPattern)
        /// Bar line symbol
        case barLine(ChordPro.Grid.BarLineSymbol)
        /// Strum symbol
        case strum(Chord.Strum)
        /// Repeating symbol
        case repeating(ChordPro.Grid.RepeatingSymbol)
        /// Chord
        /// - Note: isSpecial for "." (don't play) and "/" (play any)
        case chord(text: String, markup: Song.Markup?, isSpecial: Bool)
    }
}

extension ChordProParser {

    /// Parse the grid text into a grid token
    /// - Parameters:
    ///   - text: The text
    ///   - cellIndex: The cell index of the text
    ///   - shape: The optional shape argument of the grid directive
    ///   - markup: The optional markup of the text
    ///   - activeStrumPattern: The optional active strum pattern of the line
    ///
    /// - Returns: A grid token with its values
    private static func parseGridTextToToken(
        text: String,
        cellIndex: Int,
        shape: Song.Section.Line.Grid.Shape,
        markup: Song.Markup,
        activeStrumPattern: ChordPro.Grid.StrumPattern?
    ) -> GridToken {
        // Check if the text has markup
        let hasMarkup = !markup.open.isEmpty && !markup.close.isEmpty
        /// Check if it is a spacer or if it is text within the margins
        /// - Note: Margins are determined by shape offsets and leading whitespace
        let isWhitespace = text.starts(with: " ")
        let isLeftMargin = cellIndex < shape.left
        let isRightMargin = cellIndex >= shape.totalCells - shape.right
        if isWhitespace || isLeftMargin || isRightMargin {
            return .margin(text: text, markup: hasMarkup ? markup : nil)
        }
        /// Just plain text
        /// - Note: The '*' will be removed
        if text.starts(with: "*") {
            let stripped = String(text.dropFirst())
            var updatedMarkup = markup
            updatedMarkup.text = stripped
            return .text(text: stripped, markup: hasMarkup ? updatedMarkup : nil)
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
            let strum = Chord.Strum.characterDictionary[text] {
            return .strum(strum)
        }
        /// Repeating symbol
        if let repeating = ChordPro.Grid.RepeatingSymbol.characterDictionary[text] {
            return .repeating(repeating)
        }
        /// Chord
        /// - Note: isSpecial for "." (don't play) and "/" (play any)
        let isSpecial = (text == "." || text == "/")
        return .chord(text: text, markup: hasMarkup ? markup : nil, isSpecial: isSpecial)
    }
}