//
//  ChordPro+LineType.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro {

    /// The type of the line in a **ChordPro** song
    public enum LineType: String, Codable, Sendable {
        case songLine = "song_line"
        case emptyLine = "empty_line"
        case metadata
        case comment
        case sourceComment = "source_comment"
        case environmentDirective = "environment_directive"
        case unknown
    }
}
