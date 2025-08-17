//
//  ChordPro+LineType.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro {

    /// The type of the line in a **ChordPro** song
    enum LineType: String, Codable {
        case songLine = "song_line"
        case emptyLine = "empty_line"
        case metadata
        case comment
        case sourceComment = "source_comment"
        case environmentDirective = "environment_directive"
        case unknown

        var icon: String {
            switch self {
            case .songLine:
                "lines.measurement.vertical"
            case .emptyLine:
                "pause"
            case .metadata:
                "info"
            case .comment:
                "text.bubble"
            case .sourceComment:
                "bubble"
            case .unknown:
                "questionmark"
            case .environmentDirective:
                "arrowshape.left.arrowshape.right"
            }
        }
    }
}
