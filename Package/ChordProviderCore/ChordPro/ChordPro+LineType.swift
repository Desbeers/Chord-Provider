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

        /// Metadata
        case metadata
        /// Environment directive
        case environmentDirective = "environment_directive"
        /// Song line
        case songLine = "song_line"
        /// Comment
        case comment
        /// Chord diagram
        case chordDiagram = "chord_diagram"
        /// Grid line columns
        case gridLineColumns = "grid_line_columns"
        /// Tab line columns
        case tabLineColumns = "tab_line_columns"
        /// Empty line
        case emptyLine = "empty_line"
        /// Source comment
        case sourceComment = "source_comment"
        /// Unknown
        case unknown

        /// Display a line type as text
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
