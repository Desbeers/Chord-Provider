//
//  ChordProParser+tabToNotes.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
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
            /// The base MIDI for the string
            let midi = baseMidi[safe: lineID - stringOffset]
            /// The column ID
            var columnID = lastColumnID
            /// The visual column ID
            var visualColumnID = 0
            // Check if this line is a real tab or just text
            if line.contains("-") && line.contains("|") {
                let totalColumns = lastColumnID + line.count
                let lineCharacters = Array(line)
                /// The events of the line
                var events = (0 ..< line.count).enumerated().map { item in
                    ChordPro.Tab.Event(column: item.element, content: .filler)
                }
                // Process all columns
                while columnID < totalColumns {
                    /// Keep track of how many columns an item is using
                    var usedColumns = 1
                    let character = lineCharacters[visualColumnID]
                    // Check the content of the character
                    if character.isNumber, let midi {
                        parseNumber(
                            columnID: columnID,
                            visualColumnID: &visualColumnID,
                            lineCharacters: lineCharacters,
                            usedColumns: &usedColumns,
                            events: &events,
                            midi: midi
                        )
                    } else {
                        /// Start with an empty text content
                        var content: ChordPro.Tab.Event.Content = .filler
                        if character == "|" {
                            // MARK: Bar
                            content = .barLine
                        } else if character == "-" {
                            // MARK: Rest
                            content = .rest
                        } else {
                            // MARK: Text
                            content = .text
                        }
                        events[visualColumnID] = ChordPro.Tab.Event(
                            column: columnID,
                            content: content,
                            startIndex: visualColumnID,
                            endIndex: visualColumnID + usedColumns
                        )
                    }
                    // Keep track of the ID's
                    visualColumnID += usedColumns
                    columnID += usedColumns
                }
                return Song.Section.Line.Tab(lineID: lineID, plain: line, events: events)
            } else {
                let result = ChordPro.Tab.Event(
                    column: 1,
                    content: .text
                )
                return Song.Section.Line.Tab(lineID: lineID, plain: line, events: [result])
            }
        }
        return tabLines

        /// Helper to parse a number with optional transitions
        func parseNumber(
            columnID: Int,
            visualColumnID: inout Int,
            lineCharacters: [String.Element],
            usedColumns: inout Int,
            events: inout [ChordPro.Tab.Event] , 
            midi: IndexingIterator<Array<Int>>.Element
        ) {
            // MARK: Fret number

            var visualColumnIndex = visualColumnID
            var first = ""

            // MARK: First fret

            while visualColumnIndex < lineCharacters.count && lineCharacters[visualColumnIndex].isNumber {
                first.append(lineCharacters[visualColumnIndex])
                visualColumnIndex += 1
            }
            guard var firstNote = Int(first) else {
                return
            }
            firstNote += midi

            var from = firstNote

            usedColumns = max(
                usedColumns,
                first.count
            )

            events[visualColumnID] = ChordPro.Tab.Event(
                    column: columnID,
                    content: .fret(note: firstNote),
                    startIndex: visualColumnID,
                    endIndex: visualColumnID + usedColumns
            )

            /// Bool if the note has a transition
            var isTransition: Bool {
                if ((lineCharacters[safe: visualColumnIndex]?.isNumber) == true) {
                    return true
                }
                let symbol = String(lineCharacters[safe: visualColumnIndex] ?? .init(""))
                let transition = ChordPro.Tab.Transition.Technique.characterDictionary[symbol]
                return transition == nil ? false : true
            }

            // MARK: Optional transition

            if visualColumnIndex < lineCharacters.count {
                var transitionNotes: [Int] = []
                while isTransition, let symbolCharacter = lineCharacters[safe: visualColumnIndex] {
                    let symbol = String(symbolCharacter)
                    if let transition = ChordPro.Tab.Transition.Technique.characterDictionary[symbol] {
                        visualColumnIndex += 1
                        var second = ""
                        while visualColumnIndex < lineCharacters.count && lineCharacters[visualColumnIndex].isNumber {
                            second.append(lineCharacters[visualColumnIndex])
                            visualColumnIndex += 1
                        }
                        if var secondNote = Int(second) {
                            secondNote += midi
                            transitionNotes.append(secondNote)
                            let transition = ChordPro.Tab.Transition(
                                from: from,
                                to: secondNote,
                                by: transition
                            )
                            events[visualColumnID + usedColumns + second.count] = ChordPro.Tab.Event(
                                    column: columnID + usedColumns + second.count,
                                    content: .transition(transition: transition),
                                    startIndex: visualColumnID + usedColumns,
                                    endIndex: visualColumnIndex
                            )
                            from = secondNote
                        }
                        usedColumns = max(
                            usedColumns,
                            visualColumnIndex - visualColumnID
                        )
                    } else {
                        visualColumnIndex += 1
                    }
                }
                events[visualColumnID].transitionNote = transitionNotes.last
            }
        }
    }
}
