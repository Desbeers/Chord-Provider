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
    static func parse(id: UUID, text: String, transpose: Int, settings: AppSettings.Song, fileURL: URL?) -> Song {
        /// Start with a fresh song
        var song = Song(id: id, settings: settings)
        song.metadata.fileURL = fileURL
        /// Add the optional transpose
        song.metadata.transpose = transpose
        /// And add the first section
        var currentSection = Song.Section(id: song.sections.count + 1, autoCreated: false)
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
                if text.starts(with: "|-") || currentSection.environment == .tab {
                    /// Tab
                    processTab(text: text, song: &song, currentSection: &currentSection)
                } else {
                    /// Grid
                    processGrid(text: text, song: &song, currentSection: &currentSection)
                }
            case "":
                /// Empty line
                processEmptyLine(currentSection: &currentSection, song: &song)
            case "#":
                /// A source comment
                processSourceComment(comment: text, currentSection: &currentSection, song: &song)
            default:
                switch currentSection.environment {
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
            song.lines += 1
            closeSection(
                directive: currentSection.environment.directives.close,
                environment: currentSection.environment,
                currentSection: &currentSection,
                song: &song
            )
        }
        /// Set the first chord as key if not set manual
        if song.metadata.key == nil {
            song.metadata.key = song.chords.first
        }
        /// All done!
        return song

//        let lines = song.sections.flatMap(\.lines)
//        for line in lines {
//            print("\(line.sourceLineNumber):\t\(line.source)")
//        }

//        let encoder = JSONEncoder()
//        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
//        //encoder.keyEncodingStrategy = .convertToSnakeCase
//        do {
//            let encodedData = try encoder.encode(song)
//            let content = String(data: encodedData, encoding: .utf8) ?? "error"
//            print(content)
//        } catch {
//            print(error)
//        }

    }
}
