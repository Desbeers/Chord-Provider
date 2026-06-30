//
//  ChordPro+LineType.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordPro {

    /// The type of the line in a **ChordPro** song
    public enum LineType: String, Codable, Sendable, CaseIterable, Comparable {

        /// Comparable protocol
        /// - Note: Used for sorting
        public static func < (lhs: Self, rhs: Self) -> Bool {
            allCases.firstIndex(of: lhs) ?? 0 < allCases.firstIndex(of: rhs) ?? 1
        }

        case metadata
        case environmentDirective = "environment_directive"
        case songLine = "song_line"
        case comment
        case chordDiagram = "chord_diagram"
        case gridLineColumns = "grid_line_columns"
        case tabLineColumns = "tab_line_columns"
        case emptyLine = "empty_line"
        case sourceComment = "source_comment"
        case unknown

        public var display: String {
            switch self {
            case .metadata:
                "Metadata directives"
            case .environmentDirective:
                "Environment directives"
            case .comment:
                "Comment directives"
            case .chordDiagram:
                "Chord diagram directives"
            default:
                rawValue
            }
        }
    }
}
