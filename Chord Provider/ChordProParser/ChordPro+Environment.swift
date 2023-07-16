//
//  ChordPro+Environment.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension ChordPro {

    // MARK: 'ChordPro' section environments

    /// The environment of a section of the song
    enum Environment: String {
        /// No environment
        case none = ""
        /// Chorus environment
        case chorus = "Chorus"
        /// Repeat chorus environment
        case repeatChorus = "Repeat Chorus"
        /// Verse environment
        case verse = "Verse"
        /// Bridge environment
        case bridge = "Bridge"
        /// Comment environment
        case comment = "Comment"
        /// Tab environment
        case tab = "Tab"
        /// Grid environment
        case grid = "Grid"
    }
}
