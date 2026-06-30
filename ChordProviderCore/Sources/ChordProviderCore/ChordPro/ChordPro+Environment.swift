//
//  ChordPro+Environment.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordPro {

    // MARK: 'ChordPro' section environments

    /// The environment of a section of the song
    public enum Environment: Codable, Sendable, Equatable, Hashable {

        // MARK: Official environments

        /// Chorus environment
        case chorus
        /// Repeat chorus environment
        case repeatChorus
        /// Verse environment
        case verse
        /// Bridge environment
        case bridge
        /// Comment environment
        case comment
        /// Tab environment
        case tab
        /// Grid environment
        case grid
        /// Image environment
        case image
        /// Custom environment
        case custom(name: String)

        // MARK: Official delegated environment directives

        /// ABC environment
        case abc

        /// Lilypond environment
        case ly

        /// SVG environment
        case svg

        /// Textblock environment
        case textblock

        // MARK: Custom environments

        /// The environment contains metadata
        case metadata

        /// An empty line in the source
        case emptyLine

        /// A source comment
        case sourceComment

        /// A chord diagram
        case chordDiagram

        /// Unknown environment
        case unknown
    }
}
