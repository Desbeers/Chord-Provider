//
//  ChordPro+Directive+FormattingAttribute.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    /// Optional formatting attributes for directives
    public enum FormattingAttribute: String, Comparable, Codable, Sendable {
        /// Fallback for a simple attribute
        case plain
        /// Label
        case label
        /// Alignment
        case align
        /// Flush
        case flush
        /// Anchor
        case anchor
        /// X
        case x
        /// Y
        case y
        /// Scale
        case scale
        /// Source; used in an *{image}* directive
        case src
        /// Spread
        case spread
        /// Width
        case width
        /// Height
        case height
        /// Tuplet; used in a *{start_of_strum}* environment
        case tuplet
        /// Shape; used in grids
        case shape

        // MARK: For internal use

        /// Numeric
        case numeric
        /// Define
        case define
        /// Key
        case key
        /// Source
        case source

        /// Implement Comparable
        public static func < (lhs: FormattingAttribute, rhs: FormattingAttribute) -> Bool {
            lhs.order < rhs.order
        }
        /// This is to make a preferred order of arguments
        var order: Int {
            switch self {

            case .plain: 1
            case .label: 2
            case .align: 3
            case .flush: 4
            case .anchor: 5
            case .x: 6
            case .y: 7
            case .scale: 8
            case .src: 9
            case .spread: 10
            case .width: 11
            case .height: 12
            case .tuplet: 13
            case .numeric: 14
            case .define: 15
            case .key: 16
            case .source: 17
            case .shape: 18
            }
        }
    }
}
