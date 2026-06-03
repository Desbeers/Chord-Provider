//
//  ChordProParser+tabToNotes.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

extension ChordProParser {

    /// Convert tab lines into tab columns
    /// - Parameters:
    ///   - section: The section to convert
    ///   - instrument: The instrument
    ///
    /// - Returns: An updated section
    public static func tabToNotes(section: Song.Section, instrument: Instrument) -> Song.Section {
        /// Make a copy of the current sections
        var newSection = section
        /// Clear all the lines but keep the rest
        newSection.lines = []
        /// Collect the tab lines in the section
        var tabLines: [String] = []
        var lastColumnID: Int = 0
        /// Go to all the lines
        for line in section.lines {
            if line.context == .tab, let content = line.plain {
                /// Add the line to the tab lines for later processing
                tabLines.append(content)
            } else {
                if !tabLines.isEmpty {
                    /// Process the tab lines into columns
                    let tabColumns = parseTab(lines: tabLines, instrument: instrument, lastColumnID: lastColumnID)
                    lastColumnID += tabColumns.count
                    /// Append the columns
                    /// - Note: Its 'sourceLinenNumber' is 0 so it is ignored in the 'source view'
                    newSection.lines.append(
                        Song.Section.Line(
                            type: .tabLineColumns,
                            context: .tab,
                            tabColumns: tabColumns
                        )
                    )
                    /// Empty the tab lines
                    /// - Note: A *tab* environment can contain more than one tab, seperated by an empty line
                    tabLines = []
                }
            }
            /// Always add an existing line
            newSection.lines.append(line)
        }
        /// MIDI
        newSection.tabEvents = {
            var result: [Song.Section.Line.Tab] = []
            for line in newSection.lines {
                guard let tabs = line.tabColumns else { continue }
                result.append(contentsOf: tabs)
            }
            return result
        }()
        // Return the updated section
        return newSection
    }

    static func parseTab(
        lines: [String],
        instrument: Instrument,
        lastColumnID: Int
    ) -> [Song.Section.Line.Tab] {
        let baseMidi = instrument.tuning.reversed().map(\.midi)
        let stringOffset = max(0, lines.count - instrument.strings.count)
        /// Chop the tab lines into a tab matrix
        let tabMatrix: [[Character]] = lines.compactMap { line in
            Array(line)
        }
        /// Set the width based on the longest tab line
        guard let tabWidth = tabMatrix.map(\.count).max() else {
            return []
        }
        /// The resulting tab columns
        var tabColumns: [Song.Section.Line.Tab] = []
        /// The column ID
        var columnID = lastColumnID
        /// The visual column ID
        /// - Note: An item can occupy more than one column
        var visualColumnID = 0
        /// Process all columns
        while visualColumnID < tabWidth {
            /// Create empty events with text
            var events = tabMatrix.indices.map { lineID in
                Song.Section.Line.Tab.Event(
                    line: lineID,
                    content: .text(" ")
                )
            }
            /// Keep track of how many columns an item is using
            var usedColumns = 1
            /// Process each column
            for (lineID, lineCharacters) in tabMatrix.enumerated() {
                /// Bool if the line contains a 'rest' character
                /// - Note: If 'true' the line is considered a real tab, else just text
                let tabLine = lineCharacters.contains("-")
                /// Make sure we are withing the character range 
                guard visualColumnID < lineCharacters.count else {
                    continue
                }
                let midi = baseMidi[safe: lineID - stringOffset]
                /// Get the character in the currently visible column
                let character = lineCharacters[visualColumnID]
                /// Check the content of the character
                if tabLine, character.isNumber, let midi {

                    // MARK: Fret number

                    var visualColumnIndex = visualColumnID
                    var first = ""

                    // MARK: First fret

                    while visualColumnIndex < lineCharacters.count && lineCharacters[visualColumnIndex].isNumber {
                        first.append(lineCharacters[visualColumnIndex])
                        visualColumnIndex += 1
                    }
                    guard let fret = Int(first) else {
                        continue
                    }
                    usedColumns = max(
                        usedColumns,
                        first.count
                    )
                    /// Set the content
                    /// - Note: This can be overridden by a note transition
                    var content: Song.Section.Line.Tab.Content = .fret(display: "\(fret)", note: fret + midi, filler: "")

                    // MARK: Optional transition

                    if visualColumnIndex < lineCharacters.count {
                        let symbol = String(lineCharacters[visualColumnIndex])
                        if let transition = ChordPro.Tab.NoteTransition.characterDictionary[symbol] {
                            visualColumnIndex += 1
                            var second = ""
                            while visualColumnIndex < lineCharacters.count &&
                                lineCharacters[visualColumnIndex].isNumber
                            {
                                second.append(lineCharacters[visualColumnIndex])
                                visualColumnIndex += 1
                            }
                            if let secondFret = Int(second) {
                                /// Set the content as a transition
                                content = .transition(
                                    display: "\(fret)\(transition.display)\(secondFret)",
                                    from: fret + midi,
                                    to: secondFret + midi,
                                    transition: transition
                                )
                            }
                            usedColumns = max(
                                usedColumns,
                                visualColumnIndex - visualColumnID
                            )
                        }
                    }
                    /// Add the notes event
                    events[lineID] = Song.Section.Line.Tab.Event(
                        line: lineID,
                        content: content
                    )
                } else if character == "|" {

                    // MARK: Bar

                    events[lineID] = Song.Section.Line.Tab.Event(
                        line: lineID,
                        content: .barLine
                    )
                } else if character == "-" {

                    // MARK: Rest

                    events[lineID] = Song.Section.Line.Tab.Event(
                        line: lineID,
                        content: .rest(display: "-")
                    )
                } else {

                    // MARK: Text

                    events[lineID] = Song.Section.Line.Tab.Event(
                        line: lineID,
                        content: .text(String(character))
                    )
                }
            }
            /// Make the grid even spaced

            for (index, event) in events.enumerated() {
                if case .rest = event.content {
                    let rest = Song.Section.Line.Tab.Event(
                        line: event.line,
                        content: .rest(display: String(repeating: "-", count: usedColumns))
                    )
                    events[index] = rest
                }
                if case let .fret(display, note, _) = event.content {
                    let filler = String(repeating: "-", count: usedColumns - display.count)
                    let rest = Song.Section.Line.Tab.Event(
                        line: event.line,
                        content: .fret(display: display, note: note, filler: filler)
                    )
                    events[index] = rest
                }
            }
            
            /// Add the column
            tabColumns.append(
                Song.Section.Line.Tab(
                    instrument: instrument,
                    columnID: columnID,
                    events: events
                )
            )
            /// Keep track of the ID's
            visualColumnID += usedColumns
            columnID += 1
        }
        /// Return all the columns
        return tabColumns
    }
}
