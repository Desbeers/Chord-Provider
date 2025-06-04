//
//  ChordProParser+processMetadata.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Process meta data
    /// - Parameters:
    ///   - directive: The ``ChordPro/Directive`` to process
    ///   - arguments: The optional arguments for the directive
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processMetadata(
        directive: ChordPro.Directive,
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        /// Set this metadata as defined
        song.definedMetaData.append(directive)
        /// Get the label
        let label = arguments[.plain]
        /// Add the metadata to the song
        switch directive {

            // MARK: Official Meta-data directives

        case .title:
            song.metadata.title = label ?? song.metadata.title
        case .sortTitle:
            song.metadata.sortTitle = label ?? song.metadata.sortTitle
        case .subtitle:
            song.metadata.subtitle = label
        case .artist:
            song.metadata.artist = label ?? song.metadata.artist
        case .composer:
            if let label {
                song.metadata.composers.append(label)
            }
        case .capo:
            song.metadata.capo = label
        case .time:
            song.metadata.time = label
        case .key:
            if let label, var chord = ChordDefinition(name: label, instrument: song.settings.display.instrument) {
                /// Transpose the key if needed
                if song.metadata.transpose != 0 {
                    chord.transpose(transpose: song.metadata.transpose, scale: chord.root)
                }
                song.metadata.key = chord
            }
        case .tempo:
            song.metadata.tempo = label
        case .year:
            song.metadata.year = label
        case .album:
            song.metadata.album = label

            // MARK: Unofficial Meta-data directives

        case .sortArtist:
            song.metadata.sortArtist = label ?? song.metadata.sortArtist
        case .tag:
            if let label {
                song.metadata.tags.append(label.trimmingCharacters(in: .whitespacesAndNewlines))
            }

        default:
            break
        }
        addSection(
            sectionLabel: "",
            directive: directive,
            arguments: arguments,
            environment: .metadata,
            currentSection: &currentSection,
            song: &song
        )
    }
}
