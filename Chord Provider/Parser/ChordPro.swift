//
//  ChordPro.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import GuitarChords

/// The chordpro format parser
/// 
/// Very modified version of the "songpro-swift" parser:
///
/// [https://github.com/SongProOrg/songpro-swift](https://github.com/SongProOrg/songpro-swift)
struct ChordPro {
    
    // MARK: - Regex definitions
    /// The regex for directives with a value, {title: lalala} for example.
    static let directiveRegex = try? NSRegularExpression(pattern: "\\{(\\w*):([^%]*)\\}")
    /// The regex for directives without a value, {soc} for example.
    static let directiveEmptyRegex = try? NSRegularExpression(pattern: "\\{(\\w*)\\}")
    /// The regex for chord defines:
    static let defineRegex = try? NSRegularExpression(pattern: "([a-z0-9#b/]+)(.*)", options: .caseInsensitive)
    /// The regex for a 'normal' lyrics line:
    static let lyricsRegex = try? NSRegularExpression(pattern: "(\\[[\\w#b/]+])?([^\\[]*)", options: .caseInsensitive)
    /// The regex for a line with measures:
    static let measuresRegex = try? NSRegularExpression(pattern: "([\\[[\\w#b\\/]+\\]\\s]+)[|]*", options: .caseInsensitive)
    /// The regex for a chord:
    static let chordsRegex = try? NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]?", options: .caseInsensitive)
    
    // MARK: - func: parse; called to parse a whole song
    static func parse(document: ChordProDocument, file: URL?) -> Song {
        /// Start with a fresh song
        var song = Song()
        /// Add the path
        song.path = file
        /// And add the first section
        var currentSection = Song.Section()
        /// Parse each line of the document:
        for text in document.text.components(separatedBy: "\n") {
            if (text.starts(with: "{")) {
                processDirective(text: text, song: &song, currentSection: &currentSection)
            } else {
                processLyrics(text: text, song: &song, currentSection: &currentSection)
            }
        }
        /// Turn the song into a HTML page
        processHtml(song: &song)
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
                processComments(text: value!, song: &song, currentSection: &currentSection)
            case "soc":
                processSection(text: value!, type: "chorus", song: &song, currentSection: &currentSection)
            case "sot":
                processSection(text: value!, type: "tab", song: &song, currentSection: &currentSection)
            case "sov":
                processSection(text: value!, type: "verse", song: &song, currentSection: &currentSection)
            case "sog":
                processSection(text: value!, type: "grid", song: &song, currentSection: &currentSection)
            case "chorus":
                processSection(text: value!, type: "chorus", song: &song, currentSection: &currentSection)
                song.sections.append(currentSection)
                currentSection = Song.Section()
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
            case "soc":
                processSection(text: "Chorus", type: "chorus", song: &song, currentSection: &currentSection)
            case "sot":
                processSection(text: "Tab", type: "tab", song: &song, currentSection: &currentSection)
            case "sog":
                processSection(text: "", type: "grid", song: &song, currentSection: &currentSection)
            case "sov":
                processSection(text: "Verse", type: "verse", song: &song, currentSection: &currentSection)
            case "chorus":
                processSection(text: "Repeat chorus", type: "chorus", song: &song, currentSection: &currentSection)
                song.sections.append(currentSection)
                currentSection = Song.Section()
            default:
                break
            }
        }
    }
    
    // MARK: - func: processSection
    fileprivate static func processSection(text: String, type: String, song: inout Song, currentSection: inout Song.Section) {
        if currentSection.lines.isEmpty {
            /// There is already an empty section
            currentSection.type = type
            currentSection.name = text
        } else {
            /// Make a new section
            song.sections.append(currentSection)
            currentSection = Song.Section()
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
        let process = processChord(chord: key)
        if let index = song.chords.firstIndex(where: { $0.name == process.key.rawValue }) {
            song.chords[index].define = value
        }
    }
    
    // MARK: - func: processComments
    fileprivate static func processComments(text: String, song: inout Song, currentSection: inout Song.Section) {
        var line = Song.Section.Line()
        line.comment = text.trimmingCharacters(in: .newlines)
        /// Add the comment as a new line.
        currentSection.lines.append(line)
    }
    
    // MARK: - func: processLyrics
    fileprivate static func processLyrics(text: String, song: inout Song, currentSection: inout Song.Section) {
        if text.isEmpty {
            if !currentSection.lines.isEmpty {
                song.sections.append(currentSection)
                currentSection = Song.Section()
            }
            return
        }
        /// Start with a fresh line:
        var line = Song.Section.Line()
        if text.starts(with: "|-") || currentSection.type == "tab" {
            if currentSection.type == nil {
                currentSection.type = "tab"
            }
            line.tablature = text
        } else if text.starts(with: "| ") {
            if currentSection.type == nil {
                currentSection.type = "grid"
            }
            if let measureMatches = measuresRegex?.matches(in: text, range: NSRange(location: 0, length: text.utf16.count)) {
                
                var measures = [Song.Section.Line.Measure]()
                
                for match in measureMatches {
                    if let measureRange = Range(match.range(at: 1), in: text) {
                        let measureText = text[measureRange].trimmingCharacters(in: .newlines)
                        if let chordsMatches = chordsRegex?.matches(in: measureText, range: NSRange(location: 0, length: measureText.utf16.count)) {
                            
                            var measure = Song.Section.Line.Measure()
                            measure.chords = chordsMatches.map {
                                if let chordsRange = Range($0.range(at: 1), in: measureText) {
                                    return String(measureText[chordsRange].trimmingCharacters(in: .newlines))
                                }
                                return ""
                            }
                            measures.append(measure)
                        }
                    }
                }
                line.measures = measures
            }
        } else {
            if let matches = lyricsRegex?.matches(in: text, range: NSRange(location: 0, length: text.utf16.count)) {
                
                for match in matches {
                    var part = Song.Section.Line.Part()
                    
                    if let keyRange = Range(match.range(at: 1), in: text) {
                        part.chord = text[keyRange]
                            .trimmingCharacters(in: .newlines)
                            .replacingOccurrences(of: "[", with: "")
                            .replacingOccurrences(of: "]", with: "")
                        if currentSection.type == nil {
                            currentSection.type = "verse"
                        }
                        /// Use the first chord as key for the song if not set.
                        if song.key == nil {
                            song.key = part.chord
                        }
                        /// Save in the chord list
                        if !song.chords.contains(where: { $0.name == part.chord! }) {
                            let process = processChord(chord: part.chord!)
                            let chord = Song.Chord(name: part.chord!, key: process.key, suffix: process.suffix, define: "")
                            song.chords.append(chord)
                        }
                    } else {
                        part.chord = ""
                    }
                    if let valueRange = Range(match.range(at: 2), in: text) {
                        /// See https://stackoverflow.com/questions/31534742/space-characters-being-removed-from-end-of-string-uilabel-swift
                        /// for the funny stuff added to the string...
                        part.lyric = String(text[valueRange] + "\u{200c}")
                    } else {
                        part.lyric = ""
                    }
                    if !(part.empty) {
                        line.parts.append(part)
                    }
                }
            }
        }
        currentSection.lines.append(line)
    }
    
    // MARK: - func: processHtml; turn the song into HTML
    private static func processHtml(song: inout Song) {
        print("Convert '" + (song.title ?? "no title") + "' into HTML")
        song.html = buildSong(song: song)
    }
    
    // MARK: - func: processChord; find key and suffix
    private static func processChord(chord: String) -> (key: GuitarChords.Key, suffix: GuitarChords.Suffix) {
        
        var key: GuitarChords.Key = .c
        var suffix: GuitarChords.Suffix = .major
        
        print("Parsing chords")
        
        let chordRegex = try? NSRegularExpression(pattern: "([CDEFGABb#]+)(.*)")
        if let match = chordRegex?.firstMatch(in: chord, options: [], range: NSRange(location: 0, length: chord.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: chord) {
                var valueKey = chord[keyRange].trimmingCharacters(in: .newlines)
                /// Dirty, some chords in the database are only in the flat version....
                if valueKey == "G#" {
                    valueKey = "Ab"
                }
                key = GuitarChords.Key(rawValue: valueKey) ?? GuitarChords.Key.c
            }
            if let valueRange = Range(match.range(at: 2), in: chord) {
                /// ChordPro suffix are not always the suffixes in the database...
                var suffixString = "major"
                switch chord[valueRange] {
                case "m":
                    suffixString = "minor"
                default:
                    suffixString = String(chord[valueRange])
                }
                suffix = GuitarChords.Suffix(rawValue: suffixString.trimmingCharacters(in: .newlines)) ?? GuitarChords.Suffix.major
            } else {
                suffix = GuitarChords.Suffix.major
            }
        }
        return (key, suffix)
    }
    
}
