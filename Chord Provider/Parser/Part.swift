//
//  Part.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Song.Section.Line {
    
    /// A part of a line in the ``Song``
    struct Part {
        var chord: String?
        var lyric: String?
        var empty: Bool {
            return (chord ?? "").isEmpty && (lyric ?? "").isEmpty
        }
    }
}
