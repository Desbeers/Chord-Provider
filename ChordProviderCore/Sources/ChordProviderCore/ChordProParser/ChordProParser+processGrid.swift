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
        /// Start with a fresh line:
        var line = Song.Section.Line(
            sourceLineNumber: song.totalLines,
            source: text,
            sourceParsed: text.trimmingCharacters(in: .whitespaces),
            type: .songLine,
            context: .grid
        )
        /// Give the structs an ID
        var cellID: Int = 0
        var partID: Int = 0
        /// The line can be a strum pattern
        var isStrumPattern: ChordPro.Grid.StrumPattern?
        /// Separate the grids
        let grids = text.matches(of: RegexDefinitions.gridSeparator).map { match in
            String(match.0)
        }
        for text in grids where !text.isEmpty {
            var grid = Song.Section.Line.Grid(id: cellID)
            /// Check for pango markup
            let markup = text.markup(handleBrackets: true)
            /// Use the plain text only
            let text = markup.text
            /// Multiple chords can be put in a single cell by separating the chord names with a ~ (tilde)
            let chords = text.split(separator: "~")
            /// Collect the parts
            var parts: [Song.Section.Line.Part] = []
            for text in chords {
                let text = String(text)
                var part = Song.Section.Line.Part(id: partID)
                if text.starts(with: "*") {
                    /// This is just text
                    part.text = String(text.dropFirst())
                    parts.append(part)
                } else if let strumPattern = ChordPro.Grid.StrumPattern(rawValue: text) {
                    /// This is a *strum pattern* indication, remember it
                    isStrumPattern = strumPattern
                    part.strum = .init(strumPattern: strumPattern)
                    parts.append(part)
                } else if let barLineSymbol = ChordPro.Grid.BarLineSymbol(rawValue: text) {
                    /// This is a *bar line symbol*
                    if let isStrumPattern {
                        part.strum = .init(strumPattern: isStrumPattern)
                    } else {
                        part.strum = .init(barLineSymbol: barLineSymbol)
                    }
                    parts.append(part)
                } else if isStrumPattern != nil, let strum = Chord.strumCharacterDict[text] {
                    /// This is a *strum*
                    part.strum = .init(strum: strum)
                    parts.append(part)
                } else {
                    /// Now it should be a chord
                    if text == "." {
                        /// Do not play a chord here
                        /// Add it as a text chord
                        var result = ChordDefinition(
                            text: text,
                            kind: .textChord
                        )
                        result.strum = .noStrum
                        parts.append(
                            Song.Section.Line.Part(
                                id: partID,
                                chordDefinition: result,
                                text: text
                            )
                        )
                    } else {
                        let result = processChord(
                            chord: String(text),
                            line: &line,
                            song: &song,
                        )
                        parts.append(
                            Song.Section.Line.Part(
                                id: partID,
                                chordDefinition: result,
                                text: result.display,
                                chordMarkup: markup
                            )
                        )
                    }
                }
                partID += 1
            }
            grid.isStrumPattern = isStrumPattern == nil ? false : true
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
