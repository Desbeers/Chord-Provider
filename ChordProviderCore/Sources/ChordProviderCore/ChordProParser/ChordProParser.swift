//
//  ChordProParser.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The **ChordPro** file parser
public enum ChordProParser {

    /// A dictionary with optional arguments for a directive
    ///
    /// Examples:
    /// ```swift
    /// {start_of_verse label="First Verse"}
    /// {start_of_textblock label="Introduction" align="center" flush="left"}
    /// ```
    public typealias DirectiveArguments = [ChordPro.Directive.FormattingAttribute: String]

    // MARK: Parse a 'ChordPro' file

    /// Parse a **ChordPro** file into a ``Song`` structure
    /// - Parameters:
    ///   - song: The current ``Song``
    ///   - settings: The ``ChordProviderCore/ChordProviderSettings`` to use
    ///   - getOnlyMetadata: Bool to get only metadata of the song, defaults to `false`
    /// - Returns: An updated ``Song`` item
    public static func parse(
        song: Song,
        settings: ChordProviderSettings,
        getOnlyMetadata: Bool = false
    ) -> Song {
        /// Store the values of the current song
        let old = song
        LogUtils.shared.setLog(
            level: .info,
            category: .songParser,
            message: "Parsing \(getOnlyMetadata ? "metadata from" : "") <b>\(settings.fileURL?.lastPathComponent ?? "New Song")</b>"
        )
        /// Start with a fresh song
        var song = Song(id: song.id, content: old.content)
        /// Add the settings
        song.settings = settings
        /// And add the first section
        var currentSection = Song.Section(id: 1)
        /// Parse each line of the text, stripping newlines at the end
        /// Leading whitespace is ignored for line classification, but preserved for content processing
        for text in song.content.components(separatedBy: .newlines) {
            let trimmed = text.trimmingCharacters(in: .whitespaces)
            let firstCharacter = trimmed.first
            /// Increase the line number
            song.lines += 1
            /// Parse only metadata
            /// - Note: Used in file browser
            if getOnlyMetadata, firstCharacter == "{" {
                /// Directive
                processDirective(
                    text: text,
                    currentSection: &currentSection,
                    song: &song,
                    getOnlyMetadata: getOnlyMetadata
                )
            } else if !getOnlyMetadata {
                switch firstCharacter {
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
                case "#":
                    /// Source comment
                    processSourceComment(comment: text, currentSection: &currentSection, song: &song)
                case nil:
                    /// Empty line
                    processEmptyLine(currentSection: &currentSection, song: &song)
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
        /// Set the first chord as key if not set manually
        if song.metadata.key == nil {
            song.metadata.key = song.chords.first
        }
        /// Set default metadata if not defined in the song file
        setDefaults(song: &song, prefixes: settings.sortTokens)
        /// Sort the chords
        song.chords = song.chords.sorted(using: KeyPathComparator(\.display))
        /// Check if the song has actual content
        let sections = song.sections.uniqued(by: \.environment).map(\.environment)
        if Set(sections).isDisjoint(with: ChordPro.Environment.content) {
            song.hasContent = false
        }
        /// Check if the song has warnings or errors
        let lines = song.sections.flatMap(\.lines).compactMap(\.warnings)
        song.hasWarnings = !lines.isEmpty

        LogUtils.shared.setLog(
            level: song.hasWarnings ? .notice : .info,
            category: .songParser,
            message: "Parsing done \(song.hasWarnings ? "with" : "without") notices or warnings"
        )

        /// All done!
        return song
    }
}
