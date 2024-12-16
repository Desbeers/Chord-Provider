//
//  ChordPro+Directive+FormattingAttribute.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    /// Optional formatting attributes for directives
    enum FormattingAttribute: String, Comparable, Codable {
        case plain
        case label
        case align
        case flush
        case anchor
        case x
        case y
        case scale
        case src
        case spread
        case width
        case height

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
            }
        }
    }
}
