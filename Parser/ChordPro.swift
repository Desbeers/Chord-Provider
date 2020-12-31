import Foundation

public class ChordPro {
    static let sectionRegex = try! NSRegularExpression(pattern: "#\\s*([^$]*)")
    static let attributeRegex = try! NSRegularExpression(pattern: "\\{(\\w*):([^%]*)\\}")
    
    static let defineRegex = try! NSRegularExpression(pattern: "([a-z0-9#b/]+)(.*)", options: .caseInsensitive)
    
    static let attributeEmptyRegex = try! NSRegularExpression(pattern: "\\{(\\w*)\\}")
    static let customAttributeRegex = try! NSRegularExpression(pattern: "!(\\w*)=([^%]*)")
    static let chordsAndLyricsRegex = try! NSRegularExpression(pattern: "(\\[[\\w#b/]+])?([^\\[]*)", options: .caseInsensitive)

    static let measuresRegex = try! NSRegularExpression(pattern: "([\\[[\\w#b\\/]+\\]\\s]+)[|]*", options: .caseInsensitive)
    static let chordsRegex = try! NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]?", options: .caseInsensitive)
    static let commentRegex = try! NSRegularExpression(pattern: ">\\s*([^$]*)")

    static func parse(document: ChordProDocument, diagrams: [Diagram]) -> Song {
        /// Start with a fresh song
        var song = Song()
        /// Add the diagrams
        song.diagram = diagrams
        
        var currentSection = Sections()
        song.sections.append(currentSection)
        
        for text in document.text.components(separatedBy: "\n") {
            if (text.starts(with: "{")) {
                processAttribute(text: text, song: &song, currentSection: &currentSection)
            } else {
                processLyricsAndChords(text: text, song: &song, currentSection: &currentSection)
            }
        }
        if currentSection.lines.isEmpty {
            /// Remove this section
            song.sections.removeLast()
        }
        print("Parsing '" + (song.title ?? "no title") + "'")

        
        processHtml(song: &song)
        
        return song
    }
    
    fileprivate static func processHtml(song: inout Song) {
        print("Convert '" + (song.title ?? "no title") + "' into HTML")
        song.html = BuildSong(song: song, chords: false)
        song.htmlchords = BuildSong(song: song, chords: true)
    }
    
    fileprivate static func processAttribute(text: String, song: inout Song, currentSection: inout Sections) {
        var key: String?
        var value: String?
        // First, stuff with a value
        if let match = attributeRegex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
            }

            if let valueRange = Range(match.range(at: 2), in: text) {
                value = text[valueRange].trimmingCharacters(in: .whitespacesAndNewlines)
            }
            switch key {
                case "t":
                    song.title = value!
                case "title":
                    song.title = value!
                case "st":
                    song.artist = value!
                case "subtitle":
                    song.artist = value!
                case "artist":
                    song.artist = value!
                case "capo":
                    song.capo = value!
                case "time":
                    song.time = value!
                case "c":
                    processComments(text: value!, song: &song, currentSection: &currentSection)
                case "comment":
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
                    currentSection = Sections()
                    song.sections.append(currentSection)
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
                    song.musicpath = value!
                default:
                    break
            }
        }
        // Second, stuff without a value
        if let match = attributeEmptyRegex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
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
                    currentSection = Sections()
                    song.sections.append(currentSection)
                default:
                    break
            }
        }
    }

    fileprivate static func processSection(text: String, type: String, song: inout Song, currentSection: inout Sections) {
        if currentSection.lines.isEmpty {
            /// There is already an empty section
            currentSection.type = type
            currentSection.name = text
        } else {
            /// Make a new section
            currentSection = Sections()
            currentSection.type = type
            currentSection.name = text
            song.sections.append(currentSection)
        }
        //return section;
    }

    fileprivate static func processDefine(text: String, song: inout Song) {
        var key = ""
        var value = ""
        if let match = defineRegex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
            }

            if let valueRange = Range(match.range(at: 2), in: text) {
                value = text[valueRange].trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        song.chords.updateValue(value, forKey: key)
    }
    
    fileprivate static func processComments(text: String, song: inout Song, currentSection: inout Sections) {
        let line = Line()
        line.comment = text.trimmingCharacters(in: .newlines)
        
        currentSection.lines.append(line)
    }
    
    fileprivate static func processLyricsAndChords(text: String, song: inout Song, currentSection: inout Sections) {
        if text.isEmpty {
            if !currentSection.lines.isEmpty {
                currentSection = Sections()
                song.sections.append(currentSection)
            }
            return
        }

        let line = Line()
        
        
        if text.starts(with: "|-") || currentSection.type == "tab" {
            if ((currentSection.type) == nil) {
                currentSection.type = "tab"
            }
            line.tablature = text
        } else if text.starts(with: "| ") {
            if ((currentSection.type) == nil) {
                currentSection.type = "grid"
            }
            let measureMatches = measuresRegex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))

            var measures = [Measure]()
            
            for match in measureMatches {
                if let measureRange = Range(match.range(at: 1), in: text) {
                    let measureText = text[measureRange].trimmingCharacters(in: .newlines)
                    let chordsMatches = chordsRegex.matches(in: measureText, range: NSRange(location: 0, length: measureText.utf16.count))
                    
                    let measure = Measure()
                    measure.chords = chordsMatches.map {
                        if let chordsRange = Range($0.range(at: 1), in: measureText) {
                            return String(measureText[chordsRange].trimmingCharacters(in: .newlines))
                        }
                        
                        return ""
                    }
                    measures.append(measure)
                }
            }
            
            line.measures = measures

        //} else if ((currentSection?.type) == nil) {
        //    line.plain = text
        } else {
            let matches = chordsAndLyricsRegex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))

            for match in matches {
                let part = Part()

                if let keyRange = Range(match.range(at: 1), in: text) {
                    part.chord = text[keyRange]
                            .trimmingCharacters(in: .newlines)
                            .replacingOccurrences(of: "[", with: "")
                            .replacingOccurrences(of: "]", with: "")
                    if ((currentSection.type) == nil) {
                        currentSection.type = "verse"
                    }
                    /// Use the first chord as key for the song if not set.
                    if ((song.key) == nil) {
                        song.key = part.chord
                    }
                    /// Save in the chord list
                    
                    let chordExists = song.chords[part.chord!] != nil
                     
                    if !chordExists{
                        song.chords.updateValue("", forKey: part.chord!)
                    }
                    
                } else {
                    part.chord = ""
                }

                if let valueRange = Range(match.range(at: 2), in: text) {
                    /// See https://stackoverflow.com/questions/31534742/space-characters-being-removed-from-end-of-string-uilabel-swift
                    /// for the funny stuff added to the string...
                    part.lyric = String(text[valueRange] + "\u{200c}")
                    //part.lyric = String(text[valueRange])
                } else {
                    part.lyric = ""
                }

                if !(part.isEmpty) {
                    line.parts.append(part)
                }
            }
        }

        currentSection.lines.append(line)
    }
}
