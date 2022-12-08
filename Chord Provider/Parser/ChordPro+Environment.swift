//
//  ChordPro+Environment.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension ChordPro {

    // MARK: Section environments

    /// The environment of a section of the song
    enum Environment: String {
        case none = "None"
        case chorus = "Chorus"
        case repeatChorus = "Repeat Chorus"
        case verse = "Verse"
        case bridge = "Bridge"
        case comment = "Comment"
        case tab = "Tab"
        case grid = "Grid"
    }

}
