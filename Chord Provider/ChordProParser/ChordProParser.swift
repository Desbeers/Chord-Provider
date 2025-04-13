//
//  ChordProParser.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// The **ChordPro** file parser
actor ChordProParser {

    /// A dictionary with optional arguments for a directive
    typealias Arguments = [ChordPro.Directive.FormattingAttribute: String]

    // MARK: Parse a 'ChordPro' file

    /// Parse a ChordPro file
    /// - Parameters:
    ///   - song: The ``Song``
    /// - Returns: A ``Song`` item
    static func parse(song: Song) async -> Song {
        let old = song
        Logger.parser.info("Parsing **\(old.metadata.fileURL?.lastPathComponent ?? "New Song", privacy: .public)**")
        /// Start with a fresh song
        var song = Song(id: song.id, content: old.content, settings: old.settings)
        song.metadata.fileURL = old.metadata.fileURL
        /// Add the optional transpose
        song.metadata.transpose = old.metadata.transpose
        /// And add the first section
        var currentSection = Song.Section(id: song.sections.count + 1, autoCreated: false)
        /// Parse each line of the text, stripping newlines at the end
        for text in song.content.components(separatedBy: .newlines) {
            /// Increase the line number
            song.lines += 1
            switch text.trimmingCharacters(in: .whitespaces).prefix(1) {
            case "{":
                /// Directive
                processDirective(text: text, currentSection: &currentSection, song: &song)
            case "|":
                /// Tab or Grid
                if text.starts(with: "|-") || currentSection.environment == .tab {
                    /// Tab
                    processTab(text: text, currentSection: &currentSection, song: &song)
                } else {
                    /// Grid
                    processGrid(text: text, currentSection: &currentSection, song: &song)
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
                    processTab(text: text, currentSection: &currentSection, song: &song)
                case .strum:
                    processStrum(text: text, currentSection: &currentSection, song: &song)
                default:
                    /// Anything else
                    processLine(text: text, currentSection: &currentSection, song: &song)
                }
            }
        }
        /// Close the last section if needed
        if !currentSection.lines.isEmpty {
            song.lines += 1
            closeSection(
                currentSection: &currentSection,
                song: &song
            )
        }
        /// Set the first chord as key if not set manual
        if song.metadata.key == nil {
            song.metadata.key = song.chords.first
        }
        /// Set default metadata if not defined in the song file
        setDefaults(song: &song)
        /// Sort the chords
        song.chords = song.chords.sorted(using: KeyPathComparator(\.display))
        /// All done!
        return song
    }
}

extension ChordProParser {

    // MARK: Debug stuff

    /// Encode a struct
    /// - Parameter value: The struct
    /// - Returns: A JSON string
    static func encode<T: Codable>(_ value: T) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        //  encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let encodedData = try encoder.encode(value)
            let content = String(data: encodedData, encoding: .utf8) ?? "error"
            return content
        } catch {
            return error.localizedDescription
        }
    }

    /// Decode a JSON encoded ``Song``
    /// - Parameter string: The ``Song`` as JSON string
    static func decode(_ string: String) {
        let decoder = JSONDecoder()
        do {
            let data = Data(string.utf8)
            let sections = try decoder.decode([Song.Section].self, from: data)
            dump(sections)
        } catch {
            Logger.parser.error("\(error.localizedDescription, privacy: .public)")
        }
    }
}
