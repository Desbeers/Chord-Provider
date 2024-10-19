//
//  ChordProParser.processDirective.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a directive

    /// Process a directive
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    static func processDirective(
        text: String,
        song: inout Song,
        currentSection: inout Song.Section
    ) {
        if let match = text.firstMatch(of: RegexDefinitions.directive) {
            let directive = match.1
            var label = match.2
            /// Check if the label contains arguments
            if let attributes = label?.matches(of: RegexDefinitions.arguments) {
                for attribute in attributes where attribute.output.1 == .label {
                    label = attribute.output.2
                }
            }
            switch directive {

            case .none:
                break

                // MARK: Meta-data directives

            case .t, .title:
                song.definedMetaData.append(directive)
                song.metaData.title = label ?? song.metaData.title
            case .st, .subtitle, .artist:
                song.definedMetaData.append(directive)
                song.metaData.artist = label ?? song.metaData.artist
            case .capo:
                song.definedMetaData.append(directive)
                song.metaData.capo = label
            case .time:
                song.metaData.time = label
            case .key:
                if let label, var chord = ChordDefinition(name: label, instrument: song.settings.song.instrument) {
                    /// Transpose the key if needed
                    if song.metaData.transpose != 0 {
                        chord.transpose(transpose: song.metaData.transpose, scale: chord.root)
                    }
                    song.metaData.key = chord
                }
            case .tempo:
                song.metaData.tempo = label
            case .year:
                song.definedMetaData.append(directive)
                song.metaData.year = label
            case .album:
                song.definedMetaData.append(directive)
                song.metaData.album = label

                // MARK: Formatting directives

            case .c, .comment:
                if let label {
                    /// Start with a new line
                    var line = Song.Section.Line(id: currentSection.lines.count + 1)
                    line.comment = label
                    switch currentSection.type {
                    case .none:
                        /// A comment in its own section
                        processSection(
                            label: ChordPro.Environment.comment.rawValue,
                            type: ChordPro.Environment.comment,
                            song: &song,
                            currentSection: &currentSection
                        )
                        currentSection.lines.append(line)
                        song.sections.append(currentSection)
                        currentSection = Song.Section(id: song.sections.count + 1, autoCreated: false)
                    default:
                        /// An inline comment, e.g. inside a verse or chorus
                        currentSection.lines.append(line)
                    }
                }

                // MARK: Environment directives

                /// ## Start of Chorus
            case .soc, .startOfChorus:
                processSection(
                    label: label ?? ChordPro.Environment.chorus.rawValue,
                    type: .chorus,
                    song: &song,
                    currentSection: &currentSection
                )

                /// ## Repeat Chorus
            case .chorus:
                processSection(
                    label: label ?? ChordPro.Environment.chorus.rawValue,
                    type: .repeatChorus,
                    song: &song,
                    currentSection: &currentSection
                )
                song.sections.append(currentSection)
                currentSection = Song.Section(id: song.sections.count + 1, autoCreated: false)

                /// ## Start of Verse
            case .sov, .startOfVerse:
                processSection(
                    label: label ?? ChordPro.Environment.verse.rawValue,
                    type: .verse,
                    song: &song,
                    currentSection: &currentSection
                )

                /// ## Start of Bridge
            case .sob, .startOfBridge:
                processSection(
                    label: label ?? ChordPro.Environment.bridge.rawValue,
                    type: .bridge,
                    song: &song,
                    currentSection: &currentSection
                )

                /// ## Start of Tab
            case .sot, .startOfTab:
                processSection(
                    label: label ?? ChordPro.Environment.tab.rawValue,
                    type: .tab,
                    song: &song,
                    currentSection: &currentSection
                )

                /// ## Start of Grid
            case .sog, .startOfGrid:
                processSection(
                    label: label ?? ChordPro.Environment.grid.rawValue,
                    type: .grid,
                    song: &song,
                    currentSection: &currentSection
                )

                /// ## Start of Textblock
            case .startOfTextblock:
                processSection(
                    label: label ?? ChordPro.Environment.textblock.rawValue,
                    type: .textblock,
                    song: &song,
                    currentSection: &currentSection
                )

                /// ## Start of Strum (custom)
            case .sos, .startOfStrum:
                processSection(
                    label: label ?? ChordPro.Environment.strum.rawValue,
                    type: .strum,
                    song: &song,
                    currentSection: &currentSection
                )

                /// # End of environment

            case .eot, .endOfTab:
                /// Make sure tab lines have the same length because of scaling
                let tabs = currentSection.lines.map(\.tab)
                if let maxLength = tabs.max(by: { $1.count > $0.count })?.count {
                    for (index, line) in currentSection.lines.enumerated() {
                        currentSection.lines[index].tab += (String(repeating: " ", count: maxLength - currentSection.lines[index].tab.count))
                    }
                }
                processSection(
                    label: ChordPro.Environment.none.rawValue,
                    type: .none,
                    song: &song,
                    currentSection: &currentSection
                )

            case .eoc, .endOfChorus, .eov, .endOfVerse, .eob, .endOfBridge, .eog, .endOfGrid, .eos, .endOfTextblock, .endOfStrum:
                processSection(
                    label: ChordPro.Environment.none.rawValue,
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
            case .tag:
                if let label {
                    song.metaData.tags.append(label.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            case .instrument:
                break
            }
        }
    }
}
