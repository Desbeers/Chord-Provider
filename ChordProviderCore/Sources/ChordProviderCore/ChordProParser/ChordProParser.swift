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
    ///   - content: The (updated) content of the song
    ///   - song: The current ``Song``
    ///   - settings: The ``ChordProviderCore/ChordProviderSettings`` to use
    ///   - getOnlyMetadata: Bool to get only metadata of the song, defaults to `false`
    /// - Returns: An updated ``Song`` item
    public static func parse(
        content: String,
        song: Song,
        settings: ChordProviderSettings,
        getOnlyMetadata: Bool = false
    ) -> Song {
        let start = ContinuousClock.now
        /// Start with a fresh song
        var song = Song(id: song.id)
        defer {
            /// Close the log
            let duration = start.duration(to: .now)
            let ms = Int(
                (
                    Double(duration.components.attoseconds) / 1e15
                    + Double(duration.components.seconds) * 1000
                ).rounded()
            )
            LogUtils.shared.setLog(
                level: song.hasWarnings ? .notice : .info,
                category: .songParser,
                message: "Parsing done \(song.hasWarnings ? "with" : "without") notices or warnings in \(ms) ms"
            )
            #if DEBUG
            print("Parsing took \(ms) ms")
            #endif
        }
        LogUtils.shared.setLog(
            level: .info,
            category: .songParser,
            message: "Parsing \(getOnlyMetadata ? "metadata from" : "") <b>\(settings.fileURL?.lastPathComponent.escapeSpecialCharacters ?? "New Song")</b>"
        )
        /// Strip optional Windows line endings
        let content = content.replacingOccurrences(of: "\r\n", with: "\n")
        /// Add the content
        song.content = content
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
            song.totalLines += 1
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
            song.totalLines += 1
            closeSection(
                directive: currentSection.environment.directives.close,
                arguments: currentSection.lines.last?.arguments ?? DirectiveArguments(),
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
        /// Check if the song has actual content
        song.hasContent = song.sections.contains {
            $0.environment.hasContent
        }
        /// Set some stuff
        let lines = song.sections.flatMap(\.lines)

        /// Process grid into columns
        if lines.map(\.context).contains(.grid) {
            for (index, section) in song.sections.enumerated() where section.environment == .grid {
                let processedSection = ChordProParser.gridToColumns(section: section)
                song.sections[index] = processedSection
            }
        }

        /// Process tab into columns
        if lines.map(\.context).contains(.tab) {
            for (index, section) in song.sections.enumerated() where section.environment == .tab {
                let processedSection = ChordProParser.tabToNotes(section: section, instrument: settings.instrument)
                song.sections[index] = processedSection
            }
        }

        /// Check if the song has warnings or errors
        song.hasWarnings = !lines.compactMap(\.warnings).isEmpty
        /// Get all known chords that are in use
        /// - Note: Defined chords that are not used will be ignored
        var result = Set<ChordDefinition>()
        for line in lines where line.directive != .chord {
            /// Collect all parts
            let allParts =
                (line.parts ?? []) +
                (line.gridsLine?
                    .flatMap(\.cells)
                    .flatMap(\.parts) ?? [])
            /// Add them to the set of known chords
            result.formUnion(
                allParts
                    .lazy
                    .map(\.content)
                    .compactMap(\.getChord?.definition)
                    .filter { $0.knownChord }
            )
        }
        /// Sort the used chords
        song.chords = Array(result).sorted()

        /// Clear the provided chord definitions
        song.settings.chordDefinitions = []

        /// All done!
        return song
    }
}
