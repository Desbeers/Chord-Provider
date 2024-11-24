//
//  ChordPro+Environment.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
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

        /// Textblock environment
        case textblock

        // MARK: Custom environments

        /// Strum environment
        case strum

        /// The environment contains metadata
        case metadata

        /// No environment
        case none
    }
}

extension ChordPro.Environment {

    /// The label for the environment
    var label: String {
        switch self {
        case .chorus:
            "Chorus"
        case .repeatChorus:
            "Repeat Chorus"
        case .verse:
            "Verse"
        case .bridge:
            "Bridge"
        case .comment:
            "Comment"
        case .tab:
            "Tab"
        case .grid:
            "Grid"
        case .textblock:
            "Text Block"
        case .strum:
            "Strum"
        case .metadata:
            "Metadata"
        case .none:
            "None"
        }
    }
}
