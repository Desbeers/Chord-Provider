//
//  Song+Section+Line+Part.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension Song.Section.Line {

    /// A part in the ``Song/Section/Line``
    struct Part: Identifiable, Equatable {
        /// The unique ID
        var id: Int
        /// The optional chord ID
        var chord: ChordDefinition.ID?
        /// The optional text
        var text: String = ""
        /// Bool if the part is empty or not
        var empty: Bool {
            return chord == nil && text.isEmpty
        }
    }
}
