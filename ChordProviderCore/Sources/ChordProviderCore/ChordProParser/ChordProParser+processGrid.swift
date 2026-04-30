//
//  ChordProParser+processGrid.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation
import RegexBuilder

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
        /// Check if there is are margins at the beginning and add spaces if needed
        if text.starts(with: " "), shape.left > 0 {
            for _ in 0..<shape.left {
                /// Insert a spacer
                grids.insert(" ", at: 0)
            }
        }
        /// Check if there is are margins at the end and add spaces if needed
        if let last = text.last, shape.right > 0, String(last) == " " {
            for _ in 0..<shape.right {
                /// Append a spacer
                grids.append(" ")
            }
        }
        for (index, gridText) in grids.enumerated() {
            guard !gridText.isEmpty else { continue }
            var grid = Song.Section.Line.Grid(id: cellID)
            /// Multiple items can be put in a single cell by separating the chord names with a ~ (tilde)
            let items = gridText.split(separator: "~")
            /// Collect the parts
            var parts: [Song.Section.Line.Part] = []
            for item in items {
                /// Check for optional pango markup
                var markup = String(item).markup(handleBrackets: true)
                let haveMarkup = !markup.open.isEmpty && !markup.close.isEmpty
                /// Use the plain text only
                let text = markup.text
                var part = Song.Section.Line.Part(id: partID)
                /// Check if it is a spacer or if it is text within the margins
                let isWhitespace = text.starts(with: " ")
                let isLeftMargin = index < shape.left
                let isRightMargin = index >= shape.totalCells - shape.right
                if isWhitespace || isLeftMargin || isRightMargin {
                    /// This is a spacer or text in the margin
                    part.text = text
                    part.strum = .init(isInMargin: true)
                    part.textMarkup = [markup]
                } else if text.starts(with: "*") {
                    /// This is just text, strip the '*'
                    let text = String(text.dropFirst())
                    part.text = text
                    markup.text = text
                    part.textMarkup = [markup]
                } else if let strumPattern = ChordPro.Grid.StrumPattern.characterDictionary[text] {
                    /// This is a *strum pattern* indication, remember it
                    activeStrumPattern = strumPattern
                    part.strum = .init(strumPattern: strumPattern)
                } else if let barLineSymbol = ChordPro.Grid.BarLineSymbol.characterDictionary[text] {
                    /// This is a *bar line symbol*
                    if let activeStrumPattern {
                        part.strum = .init(strumPattern: activeStrumPattern)
                    } else {
                        part.strum = .init(barLineSymbol: barLineSymbol)
                    }
                } else if activeStrumPattern != nil, let strum = Chord.Strum.characterDictionary[text] {
                    /// This is a *strum* and will be added like that only when the line has an active strum defined
                    part.strum = .init(strum: strum)
                } else if let repeating = ChordPro.Grid.RepeatingSymbol.characterDictionary[text] {
                    /// This is a *repeating* indication
                    part.strum = .init(repeatingSymbol: repeating)
                } else {
                    /// Now it should be a chord
                    var chord = ChordDefinition(instrument: song.settings.instrument)
                    if text == "." || text == "/" {
                        /// Do not play a chord here (".") or play some chord ("/") that is not defined
                        /// Add it as a text chord
                        chord = ChordDefinition(
                            text: text == "/" ? text : "",
                            kind: text == "/" ? .anyChord : .textChord
                        )
                        chord.strum = .noStrum
                    } else {
                       chord = processChord(
                            chord: String(text),
                            line: &line,
                            song: &song,
                        )
                    }
                    part.chordDefinition = chord
                    part.chordMarkup = haveMarkup ? markup : nil
                }
                parts.append(part)
                partID += 1
            }
            grid.isStrumPattern = activeStrumPattern != nil
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
