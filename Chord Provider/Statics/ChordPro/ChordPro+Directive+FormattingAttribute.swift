//
//  ChordPro+Directive+FormattingAttribute.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    /// Optional formatting attributes for directives
    enum FormattingAttribute: String, Comparable, Codable {
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
        /// Source
        case src
        /// Spread
        case spread
        /// Width
        case width
        /// height
        case height
        /// tuplet
        case tuplet

        /// Implement Comparable
        static func < (lhs: FormattingAttribute, rhs: FormattingAttribute) -> Bool {
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
            }
        }
    }
}
