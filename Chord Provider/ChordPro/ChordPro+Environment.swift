//
//  ChordPro+Environment.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro {

    // MARK: 'ChordPro' section environments

    /// The environment of a section of the song
    enum Environment: String, Codable {

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

        // MARK: Official delegated environment directives

        /// ABC environment
        case abc

        /// Textblock environment
        case textblock

        // MARK: Custom environments

        /// Strum environment
        case strum

        /// The environment contains metadata
        case metadata

        /// Image environment
        case image

        /// An empty line in the source
        case emptyLine

        /// Not an environment
        /// - Note: A source comment or an empty line for example
        case none
    }
}
