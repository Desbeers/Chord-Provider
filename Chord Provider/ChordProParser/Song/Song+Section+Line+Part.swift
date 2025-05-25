//
//  Song+Section+Line+Part.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// A part in the ``Song/Section/Line``
    struct Part: Identifiable, Equatable, Codable {
        /// The unique ID of the part
        var id: Int
        /// The optional chord ID
        var chord: ChordDefinition.ID?
        /// The optional text
        var text: String = ""
        /// Bool if the part has content, so at least a chord or some text
        var hasContent: Bool {
            chord != nil || !text.isEmpty
        }
    }
}
