//
//  Part.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Song.Section.Line {
    
    /// A part of a line in the ``Song``
    struct Part: Identifiable {
        var id: Int
        var chord: String?
        var text: String = ""
        var empty: Bool {
            return chord == nil && text.isEmpty
        }
    }
}
