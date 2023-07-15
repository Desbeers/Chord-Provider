//
//  ChordPro.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftyChords
import SwiftlyChordUtilities

/// The `ChordPro` file parser
enum ChordPro {

    // MARK: Parse a 'ChordPro' file

    /// Parse a ChordPro file
    /// - Parameters:
    ///   - text: The text of the file
    ///   - transponse: The optional transpose of the song
    /// - Returns: A ``Song`` item
    static func parse(text: String, transpose: Int) -> Song {
        /// Start with a fresh song
        var song = Song()
        /// Add the optional transpose
        song.transpose = transpose
        /// Add a new line at the end of the text
        let text = "\(text)\n"
        /// And add the first section
        var currentSection = Song.Section(id: song.sections.count + 1)
        /// Parse each line of the text:
        for text in text.components(separatedBy: .newlines) {
            switch text.prefix(1) {
            case "{":
                /// Directive
                processDirective(text: text, song: &song, currentSection: &currentSection)
            case "|":
                /// Tab or Grid
                if text.starts(with: "|-") || currentSection.type == .tab {
                    /// Tab
                    processTab(text: text, song: &song, currentSection: &currentSection)
                } else {
                    /// Grid
                    processGrid(text: text, song: &song, currentSection: &currentSection)
                }
            case "":
                /// Empty line; close the section if it has an 'automatic type' or else close the section
                if !currentSection.lines.isEmpty {
                    if currentSection.autoType {
                        song.sections.append(currentSection)
                        currentSection = Song.Section(id: song.sections.count + 1)
                    } else {
                        song.sections.append(currentSection)
                        currentSection = Song.Section(
                            id: song.sections.count + 1,
                            label: currentSection.label,
                            type: currentSection.type
                        )
                    }
                }
            case "#":
                /// A remark; just ignore it
                break
            default:
                switch currentSection.type {
                case .tab:
                    processTab(text: text, song: &song, currentSection: &currentSection)
                default:
                    /// Anything else
                    processLine(text: text, song: &song, currentSection: &currentSection)
                }
            }
        }
        /// All done!
        return song
    }

    // MARK: Process a directive

    /// Process a directive
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    private static func processDirective(
        text: String,
        song: inout Song,
        currentSection: inout Song.Section
    ) {

        if let match = text.wholeMatch(of: directiveRegex) {

            let directive = match.1
            let label = match.2

            switch directive {

                // MARK: Meta-data directives

            case .t, .title:
                song.title = label
            case .st, .subtitle, .artist:
                song.artist = label
            case .capo:
                song.capo = label
            case .time:
                song.time = label
            case .key:
                if let label, let key = Chords.Key(rawValue: label) {
                    /// Transpose the chord if needed
                    if song.transpose != 0 {
                        var chord = getChordInfo(root: key, quality: .major )
                        chord.transpose(transpose: song.transpose, scale: key)
                        song.key = chord.root
                    } else {
                        song.key = key
                    }
                }
            case .tempo:
                song.tempo = label
            case .year:
                song.year = label
            case .album:
                song.album = label

                // MARK: Formatting directives

            case .c, .comment:
                if let label {
                    processSection(
                        label: label,
                        type: Environment.comment,
                        song: &song,
                        currentSection: &currentSection
                    )
                    song.sections.append(currentSection)
                    currentSection = Song.Section(id: song.sections.count + 1)
                }

                // MARK: Environment directives

                /// ## Start of Chorus
            case .soc, .startOfChorus:
                processSection(
                    label: label ?? Environment.chorus.rawValue,
                    type: .chorus,
                    song: &song,
                    currentSection: &currentSection
                )

                /// ## Repeat Chorus
            case .chorus:
                processSection(
                    label: label ?? Environment.repeatChorus.rawValue,
                    type: .repeatChorus,
                    song: &song,
                    currentSection: &currentSection
                )
                song.sections.append(currentSection)
                currentSection = Song.Section(id: song.sections.count + 1)

                /// ## Start of Verse
            case .sov, .startOfVerse:
                processSection(
                    label: label ?? Environment.verse.rawValue,
                    type: .verse,
                    song: &song,
                    currentSection: &currentSection
                )

                /// ## Start of Bridge
            case .sob, .startOfBridge:
                processSection(
                    label: label ?? Environment.bridge.rawValue,
                    type: .bridge,
                    song: &song,
                    currentSection: &currentSection
                )

                /// ## Start of Tab
            case .sot, .startOfTab:
                processSection(
                    label: label ?? Environment.tab.rawValue,
                    type: .tab,
                    song: &song,
                    currentSection: &currentSection
                )

                /// ## Start of Grid
            case .sog, .startOfGrid:
                processSection(
                    label: label ?? Environment.grid.rawValue,
                    type: .grid,
                    song: &song,
                    currentSection: &currentSection
                )

                /// # End of environment
            case .eoc, .endOfChorus, .eov, .endOfVerse, .eob, .endOfBridge, .eot, .endOfTab, .eog, .endOfGrid:
                processSection(
                    label: Environment.none.rawValue,
                    type: .none,
                    song: &song,
                    currentSection: &currentSection
                )

                // MARK: Chord diagrams
            case .define:
                if let label {
                    processDefine(text: label, song: &song)
                }

                // MARK: Custom directives
            case .musicPath:
                if let label {
                    song.musicPath = label
                }
            }
        }
    }

    // MARK: Process a section

    /// Process a section
    /// - Parameters:
    ///   - label: The label of the `section`
    ///   - type: The type of `section`
    ///   - song: The `song`
    ///   - currentSection: The current `section` of the `song`
    private static func processSection(label: String, type: Environment, song: inout Song, currentSection: inout Song.Section) {
        if currentSection.lines.isEmpty {
            /// There is already an empty section
            currentSection.type = type
            currentSection.label = label
        } else {
            /// Make a new section
            song.sections.append(currentSection)
            currentSection = Song.Section(id: song.sections.count + 1)
            currentSection.type = type
            currentSection.label = label
        }
    }

    // MARK: Process a chord definition

    /// Process a chord definition
    /// - Parameters:
    ///   - text: The chord definition
    ///   - song: The `song`
    private static func processDefine(text: String, song: inout Song) {
        if let match = text.wholeMatch(of: defineRegex) {
            let key = match.1
            /// Remove standard chords with the same key if there is one in the chords list
            song.chords = song.chords.filter { !($0.name == key && $0.isCustom == false) }
            /// Parse the define
            if let chord = define(from: text) {
                song.chords.append(Song.Chord(name: key, chordPosition: chord, isCustom: true))
            }
        }
    }

    // MARK: Process a tab environment

    /// Process a tab environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    private static func processTab(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line
        var line = Song.Section.Line(id: currentSection.lines.count + 1)
        line.tab = text.trimmingCharacters(in: .whitespacesAndNewlines)
        currentSection.lines.append(line)
        /// Mark the section as Tab if not set
        if currentSection.type == .none {
            currentSection.type = .tab
            currentSection.label = Environment.tab.rawValue
            currentSection.autoType = true
        }
    }

    // MARK: Process a grid environment

    /// Process a grid environment
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    private static func processGrid(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line:
        var line = Song.Section.Line(id: currentSection.lines.count + 1)
        /// Give the structs an ID
        var partID: Int = 1
        /// Seperate the grids
        let grids = text.replacingOccurrences(of: " ", with: "").split(separator: "|")
        for text in grids where !text.isEmpty {
            var grid = Song.Section.Line.Grid(id: partID)
            /// Process like a 'normal' line'
            var matches = text.matches(of: lineRegex)
            matches = matches.dropLast()
            for match in matches {
                let (_, chord, spacer) = match.output
                if let chord {
                    let result = processChord(chord: String(chord), song: &song)
                    /// Add it as chord
                    grid.parts.append(Song.Section.Line.Part(id: partID, chord: result))
                    partID += 1
                }

                if let spacer {
                    /// Add it as spacer
                    for _ in spacer {
                        grid.parts.append(Song.Section.Line.Part(id: partID, chord: nil, text: "."))
                        partID += 1
                    }
                }
            }
            line.grid.append(grid)
        }
        currentSection.lines.append(line)
        /// Mark the section as Grid if not set
        if currentSection.type == .none {
            currentSection.type = .grid
            currentSection.label = Environment.grid.rawValue
            currentSection.autoType = true
        }
    }

    // MARK: Process a line

    /// Process a line
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    private static func processLine(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line:
        var line = Song.Section.Line(id: currentSection.lines.count + 1)
        var partID: Int = 1

        var matches = text.matches(of: lineRegex)
        matches = matches.dropLast()
        for match in matches {
            let (_, chord, lyric) = match.output
            var part = Song.Section.Line.Part(id: partID)
            if let chord {
                part.chord = processChord(chord: String(chord), song: &song)
                part.text = " "
                /// Because it has a chord; it should be at least a verse
                if currentSection.type == .none {
                    currentSection.type = .verse
                    currentSection.label = Environment.verse.rawValue
                    currentSection.autoType = true
                }
            }
            if let lyric {
                /// See https://stackoverflow.com/questions/31534742/space-characters-being-removed-from-end-of-string-uilabel-swift
                /// for the funny stuff added to the string...
                part.text = String(lyric + "\u{200c}")
            }
            if !(part.empty) {
                partID += 1
                line.parts.append(part)
            }
        }
        currentSection.lines.append(line)
    }

    // MARK: Process a chord

    /// Process a chord
    /// - Parameters:
    ///   - chord: The `chord` as String
    ///   - song: The `Song`
    /// - Returns: The processed `chord` as String
    private static func processChord(chord: String, song: inout Song) -> String {
        /// Check if this chord is aready parsed
        if  let match = song.chords.first(where: { $0.name == chord }) {
            return match.display
        }
        /// Try to find the chord in SwiftyChords and append to the used chord list from this song
        let result = findRootAndQuality(chord: chord)

        if let root = result.root, let quality = result.quality {
            var rootValue = root
            /// Transpose the chord if needed
            if song.transpose != 0 {
                var chord = getChordInfo(root: rootValue, quality: quality )
                chord.transpose(transpose: song.transpose, scale: song.key ?? .c)
                rootValue = chord.root
            }
            let chords = Chords.guitar
                .filter { $0.key == rootValue && $0.suffix == quality }
                .sorted { $0.baseFret < $1.baseFret }
            if let baseChord = chords.first {
                let songChord = Song.Chord(name: chord, chordPosition: baseChord, isCustom: false)
                song.chords.append(songChord)
                return songChord.display
            }
        }
        /// Return the chord because it is possible to have a custom defined chard after the usage of that chord.
        return chord
    }
}
