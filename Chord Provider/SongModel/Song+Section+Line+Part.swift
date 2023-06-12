//
//  Song+Section+Line+Part.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// A part in the ``Song/Section/Line``
    struct Part: Identifiable {
        /// The unique ID
        var id: Int
        /// The optional chord
        var chord: String?
        /// The optional text
        var text: String = ""
        /// Bool if the part is empty or not
        var empty: Bool {
            return chord == nil && text.isEmpty
        }
    }
}
