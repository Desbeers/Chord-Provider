//
//  ChordProParser+processMetadata.swift
//  ChordProviderCore
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
    ///
    /// - Note: Metadata supports only a single plain argument
    static func processMetadata(
        directive: ChordPro.Directive,
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        /// Check if the directive is already defined and add a warning if it should only be set once
        if song.metadata.definedMetadata.contains(directive.rawValue.long), ChordPro.Directive.singleDirectives.contains(directive) {
            currentSection.addWarning("Metadata <b>\(directive.details.label)</b> is redefined; previous one will be ignored", level: .error)
        } else if ChordPro.Directive.singleDirectives.contains(directive) {
            /// Set this metadata as defined
            song.metadata.definedMetadata.insert(directive.rawValue.long)
        }
        /// Add a warning that attributes are not supported for metadata
        if arguments[.label] != nil {
            currentSection.addWarning("Metadata attributes are not supported", level: .notice)
        }
        /// Get the label; fallback to the optional label but give a warning
        let label = arguments[.plain] ?? arguments[.label]
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
                if (song.metadata.composers?.append(label)) == nil {
                    song.metadata.composers = [label]
                }
            }
        case .capo:
            song.metadata.capo = label
        case .time:
            song.metadata.time = label
        case .key:
            if let label, var chord = ChordDefinition(name: label, instrument: song.settings.instrument) {
                /// Transpose the key if needed
                if song.transposing != 0 {
                    chord.transpose(transpose: song.transposing, scale: chord.root)
                }
                song.metadata.key = chord
            }
        case .tempo:
            song.metadata.tempo = label
        case .year:
            song.metadata.year = label
        case .album:
            song.metadata.album = label
        case .transpose:
            song.metadata.transpose = Int(label ?? "0") ?? 0
        case .sortArtist:
            song.metadata.sortArtist = label ?? song.metadata.sortArtist
        case .tag:
            if let label {
                if (song.metadata.tags?.append(label)) == nil {
                    song.metadata.tags = [label]
                }
            }
        case .duration:
            song.metadata.duration = label
        case .copyright:
            song.metadata.copyright = label
        case .arranger:
            if let label {
                if (song.metadata.arrangers?.append(label)) == nil {
                    song.metadata.arrangers = [label]
                }
            }
        case .lyricist:
            if let label {
                if (song.metadata.lyricists?.append(label)) == nil {
                    song.metadata.lyricists = [label]
                }
            }
        default:
            break
        }
        addSection(
            directive: directive,
            arguments: arguments,
            currentSection: &currentSection,
            song: &song
        )
    }
}
