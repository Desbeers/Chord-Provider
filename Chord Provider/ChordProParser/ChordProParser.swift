//
//  ChordProParser.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The **ChordPro** file parser
actor ChordProParser {

    // MARK: Parse a 'ChordPro' file

    /// Parse a ChordPro file
    /// - Parameters:
    ///   - text: The text of the file
    ///   - transpose: The optional transpose of the song in the GUI
    ///   - id: The ID of the song
    ///   - instrument: The instrument of the song
    ///   - fileURL: The optional file url of the song
    /// - Returns: A ``Song`` item
    static func parse(id: UUID, text: String, transpose: Int, settings: AppSettings, fileURL: URL?) -> Song {
        /// Start with a fresh song
        var song = Song(id: id, settings: settings)
        song.metaData.fileURL = fileURL
        /// Add the optional transpose
        song.metaData.transpose = transpose
        /// And add the first section
        var currentSection = Song.Section(id: song.sections.count + 1, autoCreated: true)
        /// Parse each line of the text:
        for text in text.components(separatedBy: .newlines) {
            /// Increase the line number
            song.lines += 1
            switch text.trimmingCharacters(in: .whitespaces).prefix(1) {
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
                /// Empty line
                if !currentSection.lines.isEmpty && currentSection.autoCreated == false {
                    /// Start with a fresh line:
                    var line = Song.Section.Line(id: currentSection.lines.count + 1)
                    /// Add an empty part
                    /// - Note: Use a 'space' as text
                    let part = Song.Section.Line.Part(id: 1, chord: nil, text: " ")
                    line.parts.append(part)
                    currentSection.lines.append(line)
                } else {
                    processSection(
                        label: ChordPro.Environment.none.rawValue,
                        type: .none,
                        song: &song,
                        currentSection: &currentSection
                    )
                }
            case "#":
                /// A remark; just ignore it
                break
            default:
                switch currentSection.type {
                case .tab:
                    /// A tab can start with '|--02-3-4|', but also with 'E|--2-3-4| for example
                    processTab(text: text, song: &song, currentSection: &currentSection)
                case .strum:
                    processStrum(text: text, song: &song, currentSection: &currentSection)
                default:
                    /// Anything else
                    processLine(text: text, song: &song, currentSection: &currentSection)
                }
            }
        }
        /// Close the last section if needed
        if !currentSection.lines.isEmpty {
            song.sections.append(currentSection)
        }
        /// Set the first chord as key if not set manual
        if song.metaData.key == nil {
            song.metaData.key = song.chords.first
        }
        /// All done!
        return song
    }
}
