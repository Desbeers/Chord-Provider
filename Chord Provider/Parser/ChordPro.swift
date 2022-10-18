//
//  ChordPro.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords

/// The chordpro format parser
struct ChordPro {

    // MARK: - Regex definitions
    
    /// The regex for directives with a value, {title: lalala} for example
    static let directiveRegex = try? NSRegularExpression(pattern: "\\{(\\w*):([[^}]]*)\\}")
    /// The regex for directives without a value, {soc} for example
    static let directiveEmptyRegex = try? NSRegularExpression(pattern: "\\{(\\w*)\\}")
    /// The regex for chord define
    static let defineRegex = try? NSRegularExpression(pattern: "([a-z0-9#b/]+)(.*)", options: .caseInsensitive)
    /// The regex for a 'normal'  line
    static let lineRegex = try? NSRegularExpression(pattern: "(\\[[\\w#b/]+])?([^\\[]*)", options: .caseInsensitive)
    /// The regex for a chord (used in the text editor for macOS)
    static let chordsRegex = try? NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]?", options: .caseInsensitive)
    
    // MARK: - func: parse
    
    /// Parse a ChordPro file
    /// - Parameters:
    ///   - text: The text of the file
    ///   - file: The `URL` of the file
    /// - Returns: A ``Song`` item
    static func parse(text: String, file: URL?) -> Song {
        /// Start with a fresh song
        var song = Song()
        /// Add the path
        song.path = file
        /// And add the first section
        var currentSection = Song.Section(id: song.sections.count + 1)
        /// Parse each line of the text:
        for text in text.components(separatedBy: "\n") {
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
                /// Empty line; close the section of not empty
                if !currentSection.lines.isEmpty {
                    song.sections.append(currentSection)
                    currentSection = Song.Section(id: song.sections.count + 1)
                }
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
    
    // MARK: - func: processDirective

    fileprivate static func processDirective(text: String, song: inout Song, currentSection: inout Song.Section) {
        var key: String?
        var value: String?
        /// First, stuff with a value
        if let match = directiveRegex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
            }
            if let valueRange = Range(match.range(at: 2), in: text) {
                value = text[valueRange].trimmingCharacters(in: .whitespacesAndNewlines)
            }
            switch key {
            case "t", "title":
                song.title = value!
            case "st", "subtitle", "artist":
                song.artist = value!
            case "capo":
                song.capo = value!
            case "time":
                song.time = value!
            case "c", "comment":
                processSection(text: value!, type: .comment, song: &song, currentSection: &currentSection)
                song.sections.append(currentSection)
                currentSection = Song.Section(id: song.sections.count + 1)
            case "soc":
                processSection(text: value!, type: .chorus, song: &song, currentSection: &currentSection)
            case "sot":
                processSection(text: value!, type: .tab, song: &song, currentSection: &currentSection)
            case "sov":
                processSection(text: value!, type: .verse, song: &song, currentSection: &currentSection)
            case "sog":
                processSection(text: value!, type: .grid, song: &song, currentSection: &currentSection)
            case "chorus":
                processSection(text: value!, type: .repeatChorus, song: &song, currentSection: &currentSection)
                song.sections.append(currentSection)
                currentSection = Song.Section(id: song.sections.count + 1)
            case "define":
                processDefine(text: value!, song: &song)
            case "key":
                song.key = value!
            case "tempo":
                song.tempo = value!
            case "year":
                song.year = value!
            case "album":
                song.album = value!
            case "tuning":
                song.tuning = value!
            case "musicpath":
                if let path = song.path {
                    var musicpath = path.deletingLastPathComponent()
                    musicpath.appendPathComponent(value!)
                    song.musicpath = musicpath
                }
            default:
                break
            }
        }
        /// Second, stuff without a value
        if let match = directiveEmptyRegex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
            }
            switch key {
            case "soc", "start_of_chorus":
                processSection(text: "Chorus", type: .chorus, song: &song, currentSection: &currentSection)
            case "sot":
                processSection(text: "Tab", type: .tab, song: &song, currentSection: &currentSection)
            case "sog":
                processSection(text: "", type: .grid, song: &song, currentSection: &currentSection)
            case "sov", "start_of_verse":
                processSection(text: "Verse", type: .verse, song: &song, currentSection: &currentSection)
            case "chorus":
                processSection(text: "Repeat chorus", type: .repeatChorus, song: &song, currentSection: &currentSection)
                song.sections.append(currentSection)
                currentSection = Song.Section(id: song.sections.count + 1)
            default:
                break
            }
        }
    }
    
    // MARK: - func: processSection
    
    fileprivate static func processSection(text: String, type: Song.Section.SectionType, song: inout Song, currentSection: inout Song.Section) {
        if currentSection.lines.isEmpty {
            /// There is already an empty section
            currentSection.type = type
            currentSection.name = text
        } else {
            /// Make a new section
            song.sections.append(currentSection)
            currentSection = Song.Section(id: song.sections.count + 1)
            currentSection.type = type
            currentSection.name = text
        }
    }
    
    // MARK: - func: processDefine; chord definitions
    fileprivate static func processDefine(text: String, song: inout Song) {
        var key = ""
        var value = ""
        if let match = defineRegex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
            }
            
            if let valueRange = Range(match.range(at: 2), in: text) {
                value = text[valueRange].trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        do {
            let chord = Song.Chord(name: key, chordPosition: try ChordPosition(from: value), isCustom: true)
            song.chords.append(chord)
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    // MARK: - func: processTab
    
    fileprivate static func processTab(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line
        var line = Song.Section.Line(id: currentSection.lines.count + 1)
        line.tab = text.trimmingCharacters(in: .whitespacesAndNewlines)
        currentSection.lines.append(line)
        /// Mark the section as Tab if not set
        if currentSection.type == nil {
            currentSection.type = .tab
        }
    }
    
    // MARK: - func: processGrid
    
    fileprivate static func processGrid(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line:
        var line = Song.Section.Line(id: currentSection.lines.count + 1)
        /// Give the structs an ID
        var partID: Int = 1
        /// Seperate the grids
        let grids = text.replacingOccurrences(of: " ", with: "").split(separator: "|")
        for text in grids where !text.isEmpty {
            var grid = Song.Section.Line.Grid(id: partID)
            /// Process like a 'normal' line'
            if let matches = lineRegex?.matches(in: String(text), range: NSRange(location: 0, length: text.utf16.count)) {
                for match in matches {
                    if let keyRange = Range(match.range(at: 1), in: text) {
                        let chord = text[keyRange]
                            .trimmingCharacters(in: .newlines)
                            .replacingOccurrences(of: "[", with: "")
                            .replacingOccurrences(of: "]", with: "")
                        let result = processChord(chord: chord, song: &song)
                        
                        /// Add it as chord
                        grid.parts.append(Song.Section.Line.Part(id: partID, chord: result))
                        partID += 1
                    }
                    if let valueRange = Range(match.range(at: 2), in: text) {
                        let result = String(text[valueRange])
                        /// Add it as spacer
                        for _ in result {
                            grid.parts.append(Song.Section.Line.Part(id: partID, chord: nil, text: "."))
                            partID += 1
                        }
                    }
                }
            }
            line.grid.append(grid)
        }
        currentSection.lines.append(line)
        /// Mark the section as Grid if not set
        if currentSection.type == nil {
            currentSection.type = .grid
        }
    }
    
    // MARK: - func: processLine
    
    fileprivate static func processLine(text: String, song: inout Song, currentSection: inout Song.Section) {
        /// Start with a fresh line:
        var line = Song.Section.Line(id: currentSection.lines.count + 1)
        var partID: Int = 1
        if let matches = lineRegex?.matches(in: text, range: NSRange(location: 0, length: text.utf16.count)) {
            for match in matches {
                var part = Song.Section.Line.Part(id: partID)
                if let keyRange = Range(match.range(at: 1), in: text) {
                    let chord = text[keyRange]
                        .trimmingCharacters(in: .newlines)
                        .replacingOccurrences(of: "[", with: "")
                        .replacingOccurrences(of: "]", with: "")
                    part.chord = processChord(chord: chord, song: &song)
                    
                    if currentSection.type == nil {
                        currentSection.type = .verse
                    }
                }
                if let valueRange = Range(match.range(at: 2), in: text) {
                    /// See https://stackoverflow.com/questions/31534742/space-characters-being-removed-from-end-of-string-uilabel-swift
                    /// for the funny stuff added to the string...
                    part.text = String(text[valueRange] + "\u{200c}")
                }
                if !(part.empty) {
                    partID += 1
                    line.parts.append(part)
                }
            }
        }
        currentSection.lines.append(line)
    }

    // MARK: - func: processChord; find key and suffix
    
    private static func processChord(chord: String, song: inout Song) -> String {
        /// Check if this chord is aready parsed
        if  let match = song.chords.first(where: { $0.name == chord }) {
            return match.display
        }
        
        // try to find the chord in SwiftyChords and append to the used chord list from this song
        var key: SwiftyChords.Chords.Key?
        var suffix: SwiftyChords.Chords.Suffix = .major
        
        let chordRegex = try? NSRegularExpression(pattern: "([CDEFGABb#]+)(.*)")
        if let match = chordRegex?.firstMatch(in: chord, options: [], range: NSRange(location: 0, length: chord.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: chord) {
                var valueKey = chord[keyRange].trimmingCharacters(in: .newlines)
                /// Dirty, some chords in the database are only in the flat version....
                if valueKey == "G#" {
                    valueKey = "Ab"
                }
                key = SwiftyChords.Chords.Key(rawValue: valueKey)
            }
            if let valueRange = Range(match.range(at: 2), in: chord) {
                /// ChordPro suffix are not always the suffixes in the database...
                var suffixString: String
                switch chord[valueRange] {
                case "m":
                    suffixString = "minor"
                default:
                    suffixString = String(chord[valueRange])
                }
                suffix = SwiftyChords.Chords.Suffix(rawValue: suffixString.trimmingCharacters(in: .newlines)) ?? SwiftyChords.Chords.Suffix.major
            }
            if key != nil {
                if let baseChord = Chords.guitar.filter({ $0.key == key && $0.suffix == suffix}).first {
                    let songChord = Song.Chord(name: chord, chordPosition: baseChord, isCustom: false)
                    song.chords.append(songChord)
                    return songChord.display
                }
            }
        }
        /// Return the key because it is possible to have a custom defined chard after the usage of that chord.
        return chord
    }
}
