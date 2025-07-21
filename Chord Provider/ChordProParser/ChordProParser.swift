//
//  ChordProParser.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

/// The **ChordPro** file parser
actor ChordProParser {

    /// A dictionary with optional arguments for a directive
    ///
    /// Examples:
    /// ```swift
    /// {start_of_verse label="First Verse"}
    /// {start_of_textblock label="Introduction" align="center" flush="left"}
    /// ```
    typealias DirectiveArguments = [ChordPro.Directive.FormattingAttribute: String]

    // MARK: Parse a 'ChordPro' file

    /// Parse a **ChordPro** file into a ``Song`` structure
    /// - Parameters:
    ///   - song: The current ``Song``
    ///   - getOnlyMetadata: Bool to get only metadata of the song, defaults to `false`
    /// - Returns: An updated ``Song`` item
    static func parse(song: Song, getOnlyMetadata: Bool = false) async -> Song {
        /// Store the values of the current song
        let old = song
        Logger.parser.info("Parsing \(getOnlyMetadata ? "metadata from" : "") **\(old.metadata.fileURL?.lastPathComponent ?? "New Song", privacy: .public)**")
        /// Start with a fresh song
        var song = Song(id: song.id, content: old.content, settings: old.settings)
        song.metadata.fileURL = old.metadata.fileURL
        /// Add the optional transpose
        song.metadata.transpose = old.metadata.transpose
        /// And add the first section
        var currentSection = Song.Section(id: song.sections.count + 1)
        /// Parse each line of the text, stripping newlines at the end
        for text in song.content.components(separatedBy: .newlines) {
            /// Increase the line number
            song.lines += 1
            /// Parse only metadata
            /// - Note: Used in file browser
            if getOnlyMetadata, text.trimmingCharacters(in: .whitespaces).prefix(1) == "{" {
                /// Directive
                processDirective(
                    text: text,
                    currentSection: &currentSection,
                    song: &song,
                    getOnlyMetadata: getOnlyMetadata
                )
            } else if !getOnlyMetadata {

                switch text.trimmingCharacters(in: .whitespaces).prefix(1) {
                case "{":
                    /// Directive
                    processDirective(
                        text: text,
                        currentSection: &currentSection,
                        song: &song,
                        getOnlyMetadata: getOnlyMetadata
                    )
                case "|":
                    /// Tab or Grid
                    if text.starts(with: "| ") || currentSection.environment == .grid {
                        /// Grid
                        processGrid(text: text, currentSection: &currentSection, song: &song)
                    } else {
                        /// Tab
                        processTab(text: text, currentSection: &currentSection, song: &song)
                    }
                case "":
                    /// Empty line
                    processEmptyLine(currentSection: &currentSection, song: &song)
                case "#":
                    /// Source comment or a Markdown header
                    /// - Note: Headers are only supported in textblocks
                    processSourceComment(comment: text, currentSection: &currentSection, song: &song)
                default:
                    processEnvironment(text: text, currentSection: &currentSection, song: &song)
                }
            }
        }
        /// Close the last section if needed
        if !currentSection.lines.isEmpty {
            song.lines += 1
            closeSection(
                directive: currentSection.environment.directives.close,
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
        /// Check if the song has actual content
        let sections = song.sections.uniqued(by: \.environment).map(\.environment)
        if Set(sections).isDisjoint(with: ChordPro.Environment.content) {
            song.hasContent = false
        }
        /// All done!
        return song
    }
}
