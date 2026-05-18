//
//  ChordProParser+tabToNotes.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

extension ChordProParser {

    public static func tabToNotes(section: Song.Section, instrument: Instrument) -> Song.Section {
        var newSection = section
        newSection.lines = []
        var tabLines: [String] = []
        /// Go to all the lines
        for line in section.lines {
            if line.context == .tab, let content = line.plain {
                /// Add the line to the grid lines for later processing
                tabLines.append(content)
            } else {
                if !tabLines.isEmpty {
                    let tabColumns = parseTab(lines: tabLines, instrument: instrument)
                    let line = Song.Section.Line(type: .tabLineColumns, context: .tab, tabColumns: tabColumns)
                    newSection.lines.append(line)
                    /// Reset the tab lines
                    /// - Note: A *tab* environment can contain more than one tab, seperated by an empty line
                    tabLines = []
                }
            }
            newSection.lines.append(line)
        }
        return newSection
    }

    static func parseTab(
        lines: [String],
        instrument: Instrument
    ) -> [Song.Section.Line.Tab] {
        /// Set the total amount of strings
        let totalStrings = instrument.strings.count
        /// Strip everything in front of the first pipe
        /// - Note: Every line without a pipe will be ignored
        let processed: [[Character]] = lines.compactMap { line in
            Array(line)
        }
        /// Set the width based on the longest line
        guard let width = processed.map(\.count).max() else {
            return []
        }

        var ticks: [Song.Section.Line.Tab] = []

        var visualColumn = 0
        var tick = 0

        while visualColumn < width {
            /// Create empty events with text
            var events = processed.enumerated().map { string, _ in
                Song.Section.Line.Tab.Event(
                    string: string,
                    content: .text(" ")
                )
            }

            var consumedColumns = 1

            for (stringIndex, chars) in processed.enumerated() {

                guard visualColumn < chars.count, stringIndex < totalStrings else {
                    continue
                }

                let character = chars[visualColumn]

                // MARK: Fret number
                if character.isNumber {
                    var visualColumnIndex = visualColumn
                    var first = ""
                    // MARK: First fret
                    while visualColumnIndex < chars.count && chars[visualColumnIndex].isNumber {
                        first.append(chars[visualColumnIndex])
                        visualColumnIndex += 1
                    }
                    guard let fret = Int(first) else {
                        continue
                    }
                    consumedColumns = max(
                        consumedColumns,
                        first.count
                    )
                    var content: Song.Section.Line.Tab.Content = .fret(fret)

                    // MARK: Optinal Slide
                    if visualColumnIndex < chars.count && (chars[visualColumnIndex] == "/" || chars[visualColumnIndex] == "\\") {
                        let slideDirection: Song.Section.Line.Tab.SlideDirection = chars[visualColumnIndex] == "/" ? .up : .down
                        visualColumnIndex += 1
                        var second = ""
                        while visualColumnIndex < chars.count && chars[visualColumnIndex].isNumber {
                            second.append(chars[visualColumnIndex])
                            visualColumnIndex += 1
                        }
                        if let secondFret = Int(second) {
                            content = .slide(from: fret, to: secondFret, direction: slideDirection)
                        }
                        consumedColumns = max(
                            consumedColumns,
                            visualColumnIndex - visualColumn
                        )
                    }
                    events[stringIndex] = Song.Section.Line.Tab.Event(
                        string: stringIndex,
                        content: content
                    )
                } else if character == "|" {
                    events[stringIndex] = Song.Section.Line.Tab.Event(
                        string: stringIndex,
                        content: .barLine
                    )
                } else if character == " " {
                    events[stringIndex] = Song.Section.Line.Tab.Event(
                        string: stringIndex,
                        content: .text(" ")
                    )
                } else if character == "-" {
                    events[stringIndex] = Song.Section.Line.Tab.Event(
                        string: stringIndex,
                        content: .rest
                    )
                //}
                } else {
                    var visualColumnIndex = visualColumn
                    var text = ""
                    // MARK: First fret
                    while visualColumnIndex < chars.count && !(chars[visualColumnIndex].isWhitespace || chars[visualColumnIndex] == "|") {
                        text.append(chars[visualColumnIndex])
                        visualColumnIndex += 1
                    }
                    consumedColumns = max(
                        consumedColumns,
                        text.count
                    )
                    events[stringIndex] = Song.Section.Line.Tab.Event(
                        string: stringIndex,
                        content: .text(text)
                    )
                }
            }

            ticks.append(
                Song.Section.Line.Tab(
                    tick: tick,
                    events: events
                )
            )

            visualColumn += consumedColumns
            tick += 1
        }
        return ticks
    }
}
