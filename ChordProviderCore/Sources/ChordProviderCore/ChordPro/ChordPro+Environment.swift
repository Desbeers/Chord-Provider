//
//  ChordPro+Environment.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro {

    // MARK: 'ChordPro' section environments

    /// The environment of a section of the song
    public enum Environment: String, Codable, Sendable {

        // MARK: Official environments

        /// Chorus environment
        case chorus
        /// Repeat chorus environment
        case repeatChorus = "repeat_chorus"
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
        /// Strum environment
        case strum
        /// Image environment
        case image

        // MARK: Official delegated environment directives

        /// ABC environment
        case abc

        /// Textblock environment
        case textblock

        // MARK: Custom environments

        /// The environment contains metadata
        case metadata

        /// An empty line in the source
        case emptyLine = "empty_line"

        /// A source comment
        case sourceComment = "source_comment"

        /// Not an environment
        case none
    }
}
