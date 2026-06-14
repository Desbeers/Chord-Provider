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
        /// Shadow copy of the current sections
        var newSection = section
        // Clear all the lines but keep the rest
        newSection.lines = []
        /// The tab lines in the section
        var tabLines: [String] = []
        /// The ID of the last column
        var lastColumnID: Int = 0
        // Go to all the lines
        for line in section.lines {
            if line.context == .tab, let content = line.plain {
                // Add the line to the tab lines for later processing
                tabLines.append(content)
            } else {
                if !tabLines.isEmpty {
                    // Process the tab lines into columns
                    let tabColumns = parseTab(lines: tabLines, instrument: instrument, lastColumnID: lastColumnID)
                    lastColumnID += (tabColumns.last?.events.last?.id ?? 0) + 1 
                    // Append the columns
                    // - Its 'sourceLinenNumber' is 0 so it is ignored in the 'source view'
                    newSection.lines.append(
                        Song.Section.Line(
                            type: .tabLineColumns,
                            context: .tab,
                            tabLines: tabColumns
                        )
                    )
                    // Empty the tab lines
                    // - A *tab* environment can contain more than one tab, seperated by an empty line
                    tabLines = []
                }
            }
            // Always add an existing line
            newSection.lines.append(line)
        }
        // MIDI events
        newSection.tabEvents = {
            var result: [Song.Section.Line.Tab] = []
            for line in newSection.lines {
                guard let tabs = line.tabLines else { continue }
                result.append(contentsOf: tabs)
            }
            return result
        }()
        // Return the updated section
        return newSection
    }

    /// Convert the collected tabs lines into columns
    /// - Parameters:
    ///   - lines: The tab lines
    ///   - instrument: The instrument
    ///   - lastColumnID: The ID of the last column
    ///
    /// - Returns: Tabs in a column array
    static func parseTab(
        lines: [String],
        instrument: Instrument,
        lastColumnID: Int
    ) -> [Song.Section.Line.Tab] {
        let baseMidi = instrument.tuning.reversed().map(\.midi)
        let stringOffset = max(0, lines.count - instrument.strings.count)
        let tabLines = lines.enumerated().compactMap { (lineID, line) in
            /// The column ID
            var columnID = lastColumnID
            /// The visual column ID
            /// - Note: An item can occupy more than one column
            var visualColumnID = 0
            if line.contains("-") {
                /// Real tab
                let tabWidth = lastColumnID + line.count
                /// The column ID

                let lineCharacters: [String.Element] = Array(line)

                var events: [Song.Section.Line.Tab.Event] = []
                /// Process all columns
                while columnID < tabWidth {
                    /// Start with an empty text content
                    var content: Song.Section.Line.Tab.Content = .text("")
                    /// Keep track of how many columns an item is using
                    var usedColumns = 1
                    let midi = baseMidi[safe: lineID - stringOffset]
                    let character = lineCharacters[visualColumnID]

                    // Check the content of the character
                    if character.isNumber, let midi {

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
                        /// The content
                        /// - Note: This can be overridden by a note transition
                        content = .fret(display: "\(fret)", note: fret + midi)

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
                                    // Set the content as a transition
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
                    } else if character == "|" {
                        // MARK: Bar
                        content = .barLine
                    } else if character == "-" {
                        // MARK: Rest
                        content = .rest(display: "-")
                    } else {
                        // MARK: Text
                        content = .text(String(character))
                    }
                    events.append(
                        Song.Section.Line.Tab.Event(
                            column: columnID,
                            content: content,
                            startIndex: visualColumnID,
                            endIndex: visualColumnID + usedColumns
                        )
                    )
                    if usedColumns > 1 {
                        content = .filler
                        for index in (1..<usedColumns)  {
                            events.append(
                                Song.Section.Line.Tab.Event(
                                    column: columnID + index,
                                    content: content
                                )
                            )
                        }
                    }
                    // Keep track of the ID's
                    visualColumnID += usedColumns
                    columnID += usedColumns
                }

                return Song.Section.Line.Tab(lineID: lineID, plain: line, events: events)
            } else {
                let result = Song.Section.Line.Tab.Event(
                    column: 1,
                    content: .text(line)
                )
                return Song.Section.Line.Tab(lineID: lineID, plain: line, events: [result])
            }
        }
        return tabLines
    }
}
